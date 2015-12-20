<?php
/**
 * @author: niwi.cz
 * @date 24.10.2015
 */
namespace Go2;

// old configs loading - TODO remove /////////////////////////////////////
// Load system configuration
require_once('config.php');
// local modifications file
include_once('config-local.php');

// define constants from config
define('ROOT_DIR', $c['rootPath']);
define('ROOT_URL', $c['rootUrl']);

require 'system/vendor/autoload.php';

function conf($name) {
    global $c;
    return $c[$name];
}
////////////////////////////////////////////////////////////////////////

$app = new \Slim\App;

/**
 * @param $string
 * @return string
 */
function mb_ucfirst($string)
{
    return mb_strtoupper(mb_substr($string, 0, 1)).mb_strtolower(mb_substr($string, 1));
}

$isSys = $_GET['sys'] == 'sys';
require ROOT_DIR . '/' . ($isSys ? 'system' : 'custom') . '/modules/' . mb_strtolower($_GET['module']) . '/api/' . mb_ucfirst($_GET['endpoint']) . '.php';

// Define app routes
$app->group('/api/'. ($isSys ? 'sys/' : '') . $_GET['module'] . '/' . $_GET['endpoint'], function () {

    $handler = new EndpointHandler();
    $routes = $handler->getRoutes();
    foreach ($routes as $httpMethod => $methodRoutes) {
        foreach ($methodRoutes as $url => $functionName) {
            call_user_func([$this, mb_strtolower($httpMethod)], $url, [$handler, $functionName]);
        }
    }
});

// Run app
$app->run();