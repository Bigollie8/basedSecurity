<?php

class Database
    {
        /** TRUE if static variables have been initialized. FALSE otherwise
        */
        private static $init = FALSE;
        /** The mysqli connection object
        */
        public static $conn;
        /** initializes the static class variables. Only runs initialization once.
        * does not return anything.
        */
        public static function initialize()
        {
            if (self::$init===TRUE) return;
            self::$init = TRUE;
            self::$conn = new mysqli("162.0.228.203", "baseddepartment", "zkO6X12kx5a32JCRBa", "baseddepartment_dbFull");
        }
    }
?>