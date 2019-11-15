#include once "mysql\mysql.bi"
#define NULL 0

type mysql_database
    as string host, user, pass, dbName
    as uinteger port, flag
    
    as MYSQL ptr connection
    as MYSQL_RES ptr result
    as MYSQL_ROW row
    
    declare function connect(host as string, user as string, pass as string, dbName as string, port as uinteger = 3306, flag as uinteger = 0) as integer
    declare function get_error() as string
    declare function get_error_message() as string
    declare function get_errorNo() as uinteger
    declare function query(stmt as string) as integer
    declare function get_row_count() as uinteger
    declare function get_field_count() as uinteger
    declare function get_row() as integer
    declare function get_item(index as uinteger) as string
    declare sub close()
end type

function mysql_database.connect(host as string, user as string, pass as string, dbName as string, port as uinteger = 3306, flag as uinteger = 0) as integer
    this.connection = mysql_init(NULL)
    this.host = host
    this.user = user
    this.pass = pass
    this.dbName = dbName
    this.port = port
    this.flag = flag
    if(mysql_real_connect(this.connection, this.host, this.user, this.pass, this.dbName, this.port, NULL, this.flag) = NULL) then
        return 1
    else
        return 0
    end if
end function

function mysql_database.get_error() as string
    return "ERROR " & this.get_errorNo() & ": " & this.get_error_message()
end function

function mysql_database.get_error_message() as string
    return "'" & mysql_error(this.connection) & "'"
end function

function mysql_database.get_errorNo() as uinteger
    return mysql_errNo(this.connection)
end function

function mysql_database.query(stmt as string) as integer
    dim as integer result = mysql_query(this.connection, stmt)
    if(result = 0) then
        mysql_free_result(this.result)
        this.result = mysql_store_result(this.connection)
    end if
    return result
end function

function mysql_database.get_row_count() as uinteger
    return mysql_num_rows(this.result)
end function

function mysql_database.get_field_count() as uinteger
    return mysql_num_fields(this.result)
end function

function mysql_database.get_row() as integer
    this.row = mysql_fetch_row(this.result)
    if(row = NULL) then
        return 0
    else
        return 1
    end if
end function

function mysql_database.get_item(index as uinteger) as string
    return *this.row[index]
end function

sub mysql_database.Close()
    mysql_close(this.connection)
end sub

print(sizeof(mysql_database))
sleep
