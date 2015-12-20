<?php
/**
 * @author: niwi.cz
 * @date 24.10.2015
 */
namespace Go2;


/**
 * Gorazd system common exception.
 */
class Exception extends \Exception
{
}

abstract class BaseHandler {

    protected $routes = [];
    protected $db;


    function __construct() {
        // check whether params are set
        $params = array('dbServer', 'dbUser', 'dbPassword', 'dbDatabase');
        $missingParams = array();
        foreach ($params as $param)
        {
            if (!conf($param))
                $missingParams[] = $param;
        }
        if (count($missingParams))
            throw new Exception('Missing parameters for database connection.'/*, 5, "Nebyly zadány parametry databázového připojení. Chybějící parametry: " . implode(', ', $missingParams) . '.'*/);

        // initialize DB connection
        #var_dump($this->db->connect_errno);
        $this->db = @new \mysqli(conf('dbServer'), conf('dbUser'), conf('dbPassword'), conf('dbDatabase'));
        #var_dump($params,$this->db,$this->db->connect_errno);
        if (!$this->db or $this->db->connect_errno)
        {
            if ($this->db)
                $info = $this->db->connect_error;
            else
                $info = 'Mysqli construction error';
            throw new Exception('Database connection error'/*, 5, $info . '. DB server: "' . conf('dbServer') . '"'*/);
        }
        $this->db->query("SET NAMES utf8");

        // finish init TODO
        $this->isInit = true;
    }

    protected function addRoute($httpMethod, $url, $functionName) {
        if (!array_key_exists($httpMethod, $this->routes))
            $this->routes[$httpMethod] = [];
        $this->routes[$httpMethod][$url] = $functionName;
    }

    public function getRoutes() {
        return $this->routes;
    }
}