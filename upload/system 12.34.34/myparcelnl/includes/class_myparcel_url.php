<?php

class MyParcel_Url
{
    private $_url;

    public function __construct()
    {
        $registry = MyParcel::$registry;
        $this->_url = $registry->get('url');
    }

    public function link($route, $args = '', $secure = true)
    {
        return $this->_url->link($route, $args, $secure);
    }
}

return new MyParcel_Url();