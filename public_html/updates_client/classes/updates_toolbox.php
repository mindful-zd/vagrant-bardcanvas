<?php
namespace hng2_modules\updates_client;

class updates_toolbox
{
    private $url          = "";
    private $access_token = "";
    
    public function __construct()
    {
        global $settings;
        
        $this->url = $settings->get("modules:updates_client.server_url");
        
        if( defined("UPDATES_CLIENT_TOKEN") )
            $this->access_token = UPDATES_CLIENT_TOKEN;
        else
            $this->access_token = $settings->get("modules:updates_client.client_token");
        
        if( empty($this->url) )          $this->url = "http://bardcanvas.com";
        if( empty($this->access_token) ) $this->access_token = "public";
        
        $this->url = rtrim($this->url, "/");
    }
    
    /**
     * @param array $packages
     *
     * @return mixed
     */
    public function get_versions(array $packages)
    {
        $url    = "$this->url/api/compare_versions";
        $params = array(
            "access_token" => $this->access_token,
            "packages"     => $packages,
        );
        
        return $this->call($url, $params);
    }
    
    public function download_package($name)
    {
        $url = "$this->url/$this->access_token/get/$name";
        
        $res = $this->call($url, array(), true);
        if( substr($res, 0, 5) == "ERROR" )
            throw new \Exception("Error received from updates server: $res");
        
        return $res;
    }
    
    /**
     * @param string $url
     * @param array  $params
     * @param bool   $raw    If true, raw contents are returned
     *
     * @return mixed
     * @throws \Exception
     */
    private function call($url, $params, $raw = false)
    {
        # global $arg;
        # if( $arg["--debug"] ) echo "Opening $url... ";
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL,            $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10);
        curl_setopt($ch, CURLOPT_POST,           count($params));
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS,     http_build_query($params));
        $contents = curl_exec($ch);
    
        # if( $arg["--debug"] ) echo "done. Response:\n$contents\n";
        
        if( curl_error($ch) )
            throw new \Exception("Can't call to the remote API at {$this->url}: " . curl_error($ch));
        
        curl_close($ch);
        
        if( empty($contents) )
            throw new \Exception("Nothing has been received from the remote API");
        
        if( $raw ) return $contents;
        
        $json = json_decode($contents);
        if( empty($json) )
            throw new \Exception("Error: API response is not a valid JSON response: $contents");
        
        if( $json->message != "OK" )
            throw new \Exception("Error received from the remote API: {$json->message}");
        
        return $json->data;
    }
    
    /**
     * @param $targz
     * @param $target_path
     *
     * @return string empty|error
     */
    public function extract_targz($targz, $target_path)
    {
        $zipname = str_replace(".tgz", ".zip", $targz);
        
        try
        {
            $phar = new \PharData($targz, \RecursiveDirectoryIterator::SKIP_DOTS);
            
            if( ! class_exists("ZipArchive") )
            {
                $phar->extractTo($target_path, null, true);
            }
            else
            {
                $phar->convertToData(\Phar::ZIP);
                $zip = new \ZipArchive();
                $zip->open($zipname);
                $zip->extractTo($target_path);
                $zip->close();
            }
        }
        catch (\Exception $e)
        {
            if( file_exists($zipname) ) @unlink($zipname);
            
            return $e->getMessage();
        }
        
        if( file_exists($zipname) ) @unlink($zipname);
        
        return "";
    }
    
    public function copy_package_files($src, $dst)
    {
        global $config;
    
        if( empty($config->globals["copy_package_files_log"]) )
            $config->globals["copy_package_files_log"] = array();
    
        $dir = opendir($src);
        if( ! $dir )
        {
            $config->globals["copy_package_files_log"][] = "$src cannot be read.";
            $config->globals["copy_package_files_has_errors"] = true;
            
            return;
        }
        
        if( ! is_dir($dst) )
        {
            $display_dir = str_replace(ROOTPATH . "/", "", $dst);
            if( @mkdir($dst) )
            {
                $config->globals["copy_package_files_log"][] = "$display_dir created.";
            }
            else
            {
                $config->globals["copy_package_files_log"][] = "$display_dir cannot be created.";
                $config->globals["copy_package_files_has_errors"] = true;
                
                return;
            }
        }
        
        while( $file = readdir($dir) )
        {
            if( $file == "." || $file == ".." ) continue;
            
            $display_file = str_replace(ROOTPATH . "/", "", "$dst/$file");
            if( is_dir("$src/$file") )
            {
                $this->copy_package_files("$src/$file", "$dst/$file");
            }
            else
            {
                if( file_exists("$dst/$file") )
                {
                    $src_hash = sha1_file("$src/$file");
                    $dst_hash = sha1_file("$dst/$file");
                    
                    if($src_hash == $dst_hash)
                    {
                        # $config->globals["copy_package_files_log"][] = "$display_file not changed - skipped.";
                        
                        continue;
                    }
                }
                
                $action = file_exists("$dst/$file") ? "updated" : "copied";
                if( @copy("$src/$file", "$dst/$file") )
                {
                    $config->globals["copy_package_files_log"][] = "$display_file $action.";
                }
                else
                {
                    $config->globals["copy_package_files_log"][] = "$display_file cannot be $action!";
                    $config->globals["copy_package_files_has_errors"] = true;
                }
            }
        }
        
        closedir($dir);
    }
    
    public function remove_tempdir($src, $verbose = false)
    {
        global $config;
        
        if( empty($config->globals["remove_tempdir_log"]) )
            $config->globals["remove_tempdir_log"] = array();
        
        $dir = @opendir($src);
        if( ! $dir )
        {
            $config->globals["remove_tempdir_log"][] = "$src cannot be read.";
            $config->globals["remove_tempdir_has_errors"] = true;
            
            return;
        }
        
        while( $file = readdir($dir) )
        {
            if( $file == "." || $file == ".." ) continue;
            
            $full = "$src/$file";
            if( is_dir($full) )
            {
                $this->remove_tempdir($full, $verbose);
            }
            else
            {
                if( @unlink($full) )
                {
                    $config->globals["remove_tempdir_log"][] = "$full deleted";
                }
                else
                {
                    $config->globals["remove_tempdir_log"][] = "$full cannot be deleted";
                    $config->globals["remove_tempdir_has_errors"] = true;
                }
            }
        }
        
        closedir($dir);
        if( @rmdir($src) )
        {
            $config->globals["remove_tempdir_log"][] = "$src deleted";
        }
        else
        {
            $config->globals["remove_tempdir_log"][] = "$src cannot be deleted";
            $config->globals["remove_tempdir_has_errors"] = true;
        }
    }
}
