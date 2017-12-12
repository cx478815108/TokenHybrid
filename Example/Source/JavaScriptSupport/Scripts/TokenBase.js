class Window{

    constructor(){
        this.extension = null;
    }

    keepEventValueAlive(id,value){
        if(this.managedValue == undefined){
            this.managedValue = new Map();
        }
        this.managedValue.set(id,value);
    }

    setPriviousPageExtension(value){
        setPriviousPageExtension(value);
    }
}

var window = new Window();


function setExtension(value){
    window.extension = value;
}

function __typeof__(objClass)
{
    if ( objClass && objClass.constructor )
    {
        var strFun = objClass.constructor.toString();
        var className = strFun.substr(0, strFun.indexOf('('));
        className = className.replace('function', '');
        return className.replace(/(^\s*)|(\s*$)/ig, '');
    }
    return typeof(objClass);
}

function dumpObj(obj, depth) {

    if (depth == null || depth == undefined) {
        depth = 1;
    }
    if (typeof obj != "function" && typeof obj != "object") {
        return '('+__typeof__(obj)+')' + obj.toString();
    }

    var tab = '    ';
    var tabs = '';
    for (var i = 0; i<depth-1; i++) {
        tabs+=tab;
    }

    var output = '('+__typeof__(obj)+') {\n';

    var names = Object.getOwnPropertyNames(obj);
    for (index in names) {
        var propertyName = names[index];

        try {
            var property = obj[propertyName];
            output += (tabs+tab+propertyName + ' = ' + '('+__typeof__(property)+')' +property.toString()+ '\n');
        }catch(err) {
            output += (tabs+tab+propertyName + ' = ' + '('+__typeof__(property)+')' + '\n');
        }
    }

    var prt = obj.__proto__;
    if (typeof obj == "function") {
        prt = obj.prototype;
    }

    if (prt!=null && prt!= undefined) {
        output += (tabs+tab+'proto = ' + dumpObj(prt, depth+1) + '\n');
    }else {
        output += (tabs+tab+'proto = '+prt+' \n');
    }

    output+=(tabs+'}');
    return output;
}

function log(obj,pwd) {
    receiveLog(dumpObj(obj));
}
