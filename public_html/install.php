<?php
/**
 * Download and install script for BardCanvas bundles
 *
 * @package BardCanvas
 * @author  Alejandro Caballero - lava.caballero@gmail.com
 */

$version = "1.0.0";

chdir(__DIR__);
ini_set("register_globals",              "Off");
ini_set("display_errors",                "On");
ini_set("zlib.output_compression",       "On");
ini_set("zlib.output_compression_level", "5");
error_reporting(E_ALL & ~E_NOTICE & ~E_STRICT & ~E_DEPRECATED);
header("Content-Type: text/html; charset=utf-8");
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>BardCanvas bundle installer v<?php echo $version?></title>
    <style type="text/css">
        body { font-family: Arial, Helvetica, sans-serif; font-size: 11pt; }
        * { box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; }
        span.fixed { width: 150px; display: inline-block; }
        code { background-color: silver; }
    </style>
</head>
<body>

<h1>BardCanvas Bundle installer <span style="font-size: 12pt;">On PHP v<?php echo phpversion() ?></span></h1>

<?php
$res  = can_proceed();
$mode = $_POST["go"] == "true" ? "install" : "show_form";

#
# Inits
#

if( is_array($res) )
{
    echo "<p style='color: red;'>Can't proceed with installation due to the next issues:</p>";
    echo "<ul style='color: maroon'>\n";
    foreach($res as $item) echo "<li>$item</li>\n";
    echo "</ul>\n";
    echo "<p style='color: red;'>Please take the proper measure to fix them and reload this page.</p>";
    $mode = "none";
}

#
# Prechecs
#

if( $mode == "install" )
{
    $errors = array();
    
    if( empty($_POST["bundle"]) )
        $errors[] = "You must specify a bundle to download.";
    
    if( ! empty($_POST["token"]) && strlen($_POST["token"]) != 36 )
        $errors[] = "The token you've specified is invalid.";
    
    if( empty($_POST["bundle"]) )
        $errors[] = "You must specify a bundle to download.";
    
    if( empty($_POST["db_user"]) )
        $errors[] = "You must specify a database access user name.";
    
    if( empty($_POST["db_name"]) )
        $errors[] = "You must specify a database access database name.";
    
    #
    # Installation path check
    #
    
    if( ! empty($_POST["rootpath"]) )
    {
        $_POST["rootpath"] = str_replace("\\", "/", rtrim($_POST["rootpath"], "/\\"));
        
        if( ! is_dir($_POST["rootpath"]) )
        {
            $errors[] = "Invalid installation path. Please review it.";
        }
        else
        {
            if( filemtime(__FILE__) != filemtime("{$_POST["rootpath"]}/" . basename(__FILE__)) )
                $errors[] = "Can't validate installation path. Please review it.";
        }
    }
    
    #
    # Database checks
    #
    
    if( empty($_POST["db_host"]) ) $_POST["db_host"] = "localhost";
    if( empty($_POST["db_port"]) ) $_POST["db_port"] = "3306";
    
    try
    {
        $db = new \PDO(
            "mysql:host={$_POST["db_host"]};mysql:port={$_POST["db_port"]};dbname={$_POST["db_name"]}", $_POST["db_user"], stripslashes($_POST["db_pass"])
        );
    }
    catch(\Exception $e)
    {
        $errors[] = "Can't connect to the database using given credentials. Please check database info and try again.";
    }
    
    if( file_exists(".htaccess") )
        if( ! is_writable(".htaccess") )
            $errors[] = "There is a .htaccess file present in your document root, but can't be replaced. Please change its permissions to 777 before continuing.";
}

if( ! empty($errors) )
{
    echo "<p style='color: red;'>Can't proceed with installation due to the next issues:</p>";
    echo "<ul style='color: maroon'>\n";
    foreach($errors as $item) echo "<li>$item</li>\n";
    echo "</ul>\n";
    echo "<p style='color: red;'>Please fix them and try again.</p>";
    $mode = "show_form";
}

#
# Download
#

if( $mode == "install" )
{
    $token = empty($_POST["token"]) ? "public" : $_POST["token"];
    
    $url = "http://bardcanvas.com/{$token}/get/bundle/{$_POST["bundle"]}.tar.gz";
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL,            $url);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10);
    $res = curl_exec($ch);
    
    if( substr($res, 0, 5) == "ERROR" )
    {
        echo "<p style='color: red;'>Error received when trying to download the bundle:</p>";
        echo "<p style='color: maroon;'>$res</p>";
        echo "<p style='color: red;'>Please try again. If the problem persists, please request for help at the BardCanvas website.</p>";
        $mode = "show_form";
    }
}

#
# Extraction
#

$old_htaccess_contents = "";
if( $mode == "install" )
{
    $mode    = "finish";
    $tarname = "bundle.tgz";
    $zipname = str_replace(".tgz", ".zip", $tarname);
    file_put_contents("bundle.tgz", $res);
    chmod($tarname, 0777);
    
    if( file_exists(".htaccess") ) $old_htaccess_contents = file_get_contents(".htaccess");
    
    try
    {
        $phar = new \PharData($tarname, \RecursiveDirectoryIterator::SKIP_DOTS);
        $phar->convertToData(\Phar::ZIP);
        @unlink($tarname);
        
        $zip = new \ZipArchive();
        $zip->open($zipname);
        $zip->extractTo(__DIR__);
        $zip->close();
        @unlink($zipname);
    }
    catch(\Exception $e)
    {
        echo "<p style='color: red;'>Error while extracting files:</p>";
        echo "<p style='color: maroon;'>{$e->getMessage()}</p>";
        echo "<p style='color: red;'>Please try again. If the problem persists, please request for help at the BardCanvas website.</p>";
        $mode = "show_form";
    }
    
    if( ! empty($old_htaccess_contents) )
    {
        $generated_htaccess_contents = file_get_contents(".htaccess");
        $generated_htaccess_contents = str_replace("# .htaccess Sample", "# Generated .htaccess directives by install script", $generated_htaccess_contents);
        
        $new_htaccess_contents
            = "\n"
            . "#####################################\n"
            . "# Begin Previous .htaccess contents #\n"
            . "#####################################\n"
            . "\n"
            . trim($old_htaccess_contents) . "\n"
            . "\n"
            . "###################################\n"
            . "# End Previous .htaccess contents #\n"
            . "###################################\n"
            . "\n"
            . trim($generated_htaccess_contents) . "\n"
        ;
        file_put_contents(".htaccess", $new_htaccess_contents);
    }
    
    @chmod("data", 0777);
    @chmod("logs", 0777);
}

#
# Preconfiguration
#

if( $mode == "finish" )
{
    $files = glob("*");
    if( count(array_diff(array("config-sample.php", "data", "logs"), $files)) > 0 )
    {
        echo "<p style='color: red;'>Error after extracting files:</p>";
        echo "<p style='color: maroon;'>critical files doesn't seem to exist. Extraction may be corrupted.</p>";
        echo "<p style='color: red;'>Please try again. If the problem persists, please request for help at the BardCanvas website.</p>";
        $mode = "show_form";
    }
}

if( $mode == "finish" )
{
    $contents     = file_get_contents("config-sample.php");
    $replacements = array(
        'BIG_RANDOM_SRING_HERE'             => md5(mt_rand(100000, 999999)) . md5(mt_rand(100000, 999999)),
        'mybcweb'                           => $_POST["website_id"],
        'MYSQL_USER'                        => $_POST["db_user"],
        'MYSQL_PASSWORD'                    => $_POST["db_pass"],
        'MYSQL_DATABASE'                    => $_POST["db_name"],
        'ini_set("display_errors", "Off");' => 'ini_set("display_errors", "On");',
    );
    
    if( ! empty($_POST["rootpath"]) ) $replacements["__DIR__"] = "'{$_POST["rootpath"]}'";
    
    $contents = str_replace(array_keys($replacements), $replacements, $contents);
    file_put_contents("config.php", $contents);
}

if( $mode == "finish"): ?>
    
    <p style="color: green">
        Installation complete!
    </p>
    
    <p>
        Now you need to review and complete setup.
    </p>
    
    <?php
    if( ! empty($_POST["token"]) ) echo "
        <p style='color: maroon;'>
            <b>Important:</b> the token you specified <u>was only used to download</u> the bundle.<br>
            Once you finish the setup process, you must login as admin, go to the settings page
            and specify it in the Updates section <u>or you wont be able to update</u> the
            premium modules included in the bundle.
        </p>
    ";
    ?>
    
    <p>
        <a href="setup.php">Click here to continue</a>
    </p>
    
<?php elseif( $mode == "show_form" ): ?>
    
    <p>
        This script will download and install a BardCanvas bundle into the current directory.
        Please fill the details below to get started.
    </p>
    
    <form method="post" action="<?php echo $_SERVER["PHP_SELF"] ?>">
        
        <input type="hidden" name="go" value="true">
        
        <?php if( stristr(__DIR__, $_SERVER["DOCUMENT_ROOT"]) === false ): ?>
            <h2>Installation destination</h2>
            <blockquote>
                
                <p>Note: there's a mapping difference between your physical document root path and the
                server's document root path. This will be adjusted automatically for you.</p>
                
                <p>
                    <span class="fixed">Current directory:</span>
                    <input type="text" readonly size="30" value="<?php echo __DIR__ ?>"
                           style="background-color: silver;">
                </p>
                
                <p>
                    <span class="fixed">Server document root:</span>
                    <input type="text" readonly size="30" value="<?php echo $_SERVER["DOCUMENT_ROOT"] ?>"
                           style="background-color: silver;">
                </p>
                
                <?php if( empty($_POST["rootpath"]) ) $_POST["rootpath"]
                    = rtrim( $_SERVER["DOCUMENT_ROOT"] . dirname($_SERVER["PHP_SELF"]), "/\\" ) ?>
                <p>
                    <span class="fixed">Destination path:</span>
                    <input type="text" readonly name="rootpath" size="30" value="<?php echo str_replace("\\", "/", $_POST["rootpath"]) ?>"
                           style="background-color: greenyellow;">
                </p>
                
            </blockquote>
        <? endif; ?>
        
        <?php
        if( file_exists(".htaccess") )
        {
            $htaccess_contents = file_get_contents(".htaccess");
            
            if( stristr($htaccess_contents, "scripts/document_handler.php") !== false )
            {
                echo "
                    <div style='color: maroon'>
                        <h2>Warning: a .htaccess with BardCanvas directives is present!</h2>
                        <blockquote>
                            <p>
                                This installer honors previous .htaccess directives to keep configurations set
                                by your hostmaster (like the PHP version set to the website), but the file
                                contains BardCanvas directives.
                            </p>
                            <p>
                                If you continue, new BardCanvas directives are going to be added, and that
                                may cause unexpected behavior on your website.
                            </p>
                            <p>
                                You should either delete the existing .htaccess file or download it, remove the
                                BardCanvas rulesets and reupload it before continuing.
                            </p>
                        </blockquote>
                    </div>
                ";
            }
            else
            {
                $htaccess_contents = htmlspecialchars($htaccess_contents);
                echo "
                    <div style='color: blue'>
                        <h2>Important: a .htaccess file is present!</h2>
                        <blockquote>
                            <p>
                                These are the configuration directives present in the file:
                            </p>
                            <pre style='background-color: silver'>{$htaccess_contents}</pre>
                            <p>
                                Important things are usually kept in here, like the PHP version used for a website.
                                For this reason, those directives will be inserted at the top of the BardCanvas .htaccess file.
                            </p>
                        </blockquote>
                    </div>
                ";
            }
        }
        ?>
        
        <h2>Select bundle type</h2>
        <blockquote>
            <?php if( empty($_POST["bundle"]) ) $_POST["bundle"] = "bardcanvas"; ?>
            <p>
                <label>
                    <input type="radio" <?php if($_POST["bundle"] == "bardcanvas") echo "checked"; ?> name="bundle" value="bardcanvas">
                    BardCanvas base (free) bundle.
                </label>
            </p>
            <p>
                <label>
                    <input type="radio" <?php if($_POST["bundle"] == "antitrolls") echo "checked"; ?> name="bundle" value="antitrolls">
                    Antitrolls Bundle.
                </label>
                <span style="color: maroon;">Requires a download token!</span>
                <a href="http://bardcanvas.com/antitrolls-bundle" target="_blank">Details and price here</a>.
            </p>
            <p>
                <label>
                    <input type="radio" <?php if($_POST["bundle"] == "magazine") echo "checked"; ?> name="bundle" value="magazine">
                    Magazine Bundle.
                </label>
                <span style="color: maroon;">Requires a download token!</span>
                <a href="http://bardcanvas.com/magazine-bundle" target="_blank">Details and price here</a>.
            </p>
            <p>
                <label>
                    <input type="radio" <?php if($_POST["bundle"] == "forum") echo "checked"; ?> name="bundle" value="forum">
                    Forum Bundle.
                </label>
                <span style="color: maroon;">Requires a download token!</span>
                <a href="http://bardcanvas.com/forum-bundle" target="_blank">Details and price here</a>.
            </p>
            <p>
                <label>
                    <input type="radio" <?php if($_POST["bundle"] == "allstar") echo "checked"; ?> name="bundle" value="allstar">
                    All-Star Social Network Bundle.
                </label>
                <span style="color: maroon;">Requires a download token!</span>
                <a href="http://bardcanvas.com/allstar-bundle" target="_blank">Details and price here</a>.
            </p>
            <p>
                <label>
                    <input type="radio" <?php if($_POST["bundle"] == "triklet") echo "checked"; ?> name="bundle" value="triklet">
                    Triklet Bundle.
                </label>
                <span style="color: maroon;">Requires a download token!</span>
                More info at <a href="http://lavasoftworks.com/triklet" target="_blank">lavasoftworks.com/triklet</a>.
            </p>
            
            <p>
                <span class="fixed">Download token:</span>
                <input name="token" type="text" size="32" value="<?php echo $_POST["token"] ?>">
            </p>
            <p style="color: maroon">
                <b>Note:</b> any token you specify here will be used <u>only to download the package</u>.<br>
                Once the install/setup process ends, you will have to enter it on the
                Updates section of the settings page.
            </p>
        </blockquote>
        
        <h2>Website identifier: <input name="website_id" type="text" size="10" value="<?php echo empty($_POST["website_id"]) ? "mybcweb" : $_POST["website_id"] ?>"></h2>
        <blockquote>
            Type a short, lowercase, alphanumeric identifier for your website.
            It will be used to separate cookies and temporary files.<br>
            You can use, E.G., <code>awstore</code> if your website is <code>www.myawesomestore.com</code>.
        </blockquote>
        
        <h2>Database info:</h2>
        <blockquote>
            <p>
                You must create a MySQL database and specify details here.
            </p>
            
            <p>
                <span class="fixed">Host:</span>
                <input type="text" name="db_host" value="<?php echo empty($_POST["db_host"]) ? "localhost" : $_POST["db_host"] ?>">
            </p>
            
            <p>
                <span class="fixed">Port:</span>
                <input type="text" name="db_port" value="<?php echo empty($_POST["db_port"]) ? "3306" : $_POST["db_port"] ?>">
            </p>
            
            <p>
                <span class="fixed">User:</span>
                <input type="text" name="db_user" value="<?php echo $_POST["db_user"] ?>">
            </p>
            
            <p>
                <span class="fixed">Password:</span>
                <input type="text" name="db_pass" value="<?php echo $_POST["db_pass"] ?>">
            </p>
            
            <p>
                <span class="fixed">Database name:</span>
                <input type="text" name="db_name" value="<?php echo $_POST["db_name"] ?>">
            </p>
        </blockquote>
        
        <p>
            <button type="submit">Proceed &gt;&gt;</button>
        </p>
    </form>
    
<?php endif; ?>

</body>
</html>
<?php

/**
 * @return true|array
 */
function can_proceed()
{
    $issues = array();
    
    if( ! ini_get("short_open_tag") ) return array("
        PHP configuration setting <code>short_open_tag</code> seems to be disabled. It is required by
        most BardCanvas modules. Please ask your hostmaster to enable it for you in the server's <code>php.ini</code>
        file or on your home directory.
    ");
    
    if( file_exists("data/installed") ) return array("
        A BardCanvas installation exists on the current directory.
    ");
    
    if( ! function_exists("curl_exec") ) return array("
        PHP CURL extension seems to be disabled. Cannot continue.
    ");
    
    if( ! class_exists("PDO") ) return array("
        PDO class wasn't found. PHP PDO extension seems to be disabled. Cannot continue.
    ");
    
    if( ! class_exists("Phar") ) return array("
        Phar class wasn't found. PHAR handling doesn't seem to be compiled in PHP. Cannot continue.
    ");
    
    if( ! class_exists("ZipArchive") ) return array("
        ZipArchive class wasn't found. Zip handling doesn't seem to be compiled in PHP. Cannot continue.
    ");
    
    if( ! is_writable(__DIR__) ) $issues[] = "
        Current directory is not writable. PHP is either running as Dynamic Shared object
        (processses owned by <code>nobody</code>, <code>www-data</code>, <code>apache</code>, etc.)
        and not as CGI (processes owned by your user account) or the directory is write protected.<br>
        You may try to change the directory permissions to rwxrwxrwx (chmod 0777) and try again, then,
        restore them back to their previous permissions after setup, but you may not be able to
        do it if the server has strict security policies.
    ";
    
    return empty($issues) ? true : $issues;
}
