var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var net = require('net');
var fs = require('fs');

var routes = require('./routes/index');
var users = require('./routes/users/users');
var gateways = require('./routes/gateways/gateways');
var configurations = require('./routes/configurations/configurations');
var services = require('./routes/gateways/services');
var hardware = require('./routes/hardware/hardware');
var resources = require('./routes/hardware/resources');
var sites = require('./routes/sites/sites');
var tableBss = require('./routes/tableBss/tableBss');
var externalResources = require('./routes/externalResources/externalResources');
var radioDestinations = require('./routes/destinations/radioDestinations');
var hrr = require('./routes/hrr/hrr');
var historics = require('./routes/historics/historics');
var version = require('./routes/version/version');
var logging = require('./lib/loggingDate.js');
var config = require('./configUlises.json');
//var controlAccess=require('./routes/services/accessControl');
var myLibHistorics = require('./lib/historics.js');
var myLibConfig = require('./lib/configurations.js');
var myLibHardwareGateways = require('./lib/hardware.js');
var myLibExtResources = require('./lib/externalResources.js');
var jsonTemplate = require('./lib/jsonTemplate');

var jsgtw = require('./public/javascripts/gateways.js');

/** 20170525. AGL. Para el control de Sesiones. */
var passport = require('passport');
var Strategy = require('passport-local').Strategy;
var flash = require('connect-flash');
var moment = require('moment');
var ctrlSesiones = { user: null, localSession: null };
var aliveGtws = [];

/** 20180829. Variables de Entorno en Base de Datos */
process.env.DB_HOST = process.env.DB_HOST || config.Ulises.dbhost;
process.env.DB_BASE = process.env.DB_BASE || config.Ulises.dbdatabase;
process.env.DB_USER = process.env.DB_USER || config.Ulises.dbuser;
process.env.DB_PASS = process.env.DB_PASS || config.Ulises.dbpassword;
//{ip:'',online:'',time:''}

/***/
// Configure the local strategy for use by Passport.
//
// The local strategy require a `verify` function which receives the credentials
// (`username` and `password`) submitted by the user.  The function must verify
// that the password is correct and then invoke `cb` with a user object, which
// will be set at `req.user` in route handlers after authentication.
var ID_HW = 'CFG';
var ACCESS_SYSTEM_OK = 50;
var ACCESS_SYSTEM_FAIL = 51;
var USER_LOGOUT_SYSTEM = 55;
function insertHistoric(code, user, reason) {
    myLibHistorics.postHistorics(
        {
            IdIncidencia: code,
            IdHw: ID_HW,
            Usuario: user,
            Param: reason
        }
        , function (h) {
            //console.log("insertHistoric: " + h);
        });
}
function checkPerfil(userprofile) {
    var allProfMsc = (0x0001 | 0x0010 | 0x0040 | 0x0200 | 0x0400 | 0x8000);
    var valProfile = ((userprofile & allProfMsc) ? true : false);
    return valProfile;
}
passport.use(new Strategy(
    function (username, password, cb) {
        logging.LoggingDateCond('Passport Strategy function: ' + username + '/' + password, config.Ulises.LoginSystemTrace);
        if (ctrlSesiones.localSession) {
            insertHistoric(ACCESS_SYSTEM_FAIL, username, 'Existe una sesion activa.');
            return cb(null, false, { message: 'Existe una sesion activa.' });
        }
        var pwdB64 = new Buffer(password).toString('base64');
        require("./lib/users").findByUsername(username, function (err, user) {
            if (err) {
                insertHistoric(ACCESS_SYSTEM_FAIL, username, err);
                return cb(err);
            }
            if (!user) {
                insertHistoric(ACCESS_SYSTEM_FAIL, username, 'No existe el usuario');
                return cb(null, false, { message: 'No existe el usuario' });
            }
            if (checkPerfil(user.perfil) == false) {
                insertHistoric(ACCESS_SYSTEM_FAIL, username, 'Perfil de usuario no adecuado');
                return cb(null, false, { message: 'Perfil de usuario no adecuado' });
            }
            if (user.clave != pwdB64) {
                insertHistoric(ACCESS_SYSTEM_FAIL, username, 'Password incorrecta.');
                return cb(null, false, { message: 'Password incorrecta.' });
            }
            insertHistoric(ACCESS_SYSTEM_OK, user.name, '');
            return cb(null, user);
        });
    }));


// Configure Passport authenticated session persistence.
//
// In order to restore authentication state across HTTP requests, Passport needs
// to serialize users into and deserialize users out of the session.  The
// typical implementation of this is as simple as supplying the user ID when
// serializing, and querying the user record by ID from the database when
// deserializing.
passport.serializeUser(function (user, cb) {
    ctrlSesiones.user = user;
    cb(null, user.idOPERADORES);
    logging.LoggingDateCond('serializeUser: ' + user.idOPERADORES.toString() + ', ' + user.perfil.toString(), config.Ulises.LoginSystemTrace);
});
passport.deserializeUser(function (id, cb) {
    // require("./lib/users").findById(id, function (err, user) {
    //   if (err) { return cb(err); }
    //   cb(null, user);
    //   console.log('deserializeUser: ' + id.toString());
    // });
    logging.LoggingDateCond('deserializeUser: ' + id.toString(), config.Ulises.LoginSystemTrace);
    if (ctrlSesiones.user)
        return cb(null, ctrlSesiones.user);
    return cb("No hay usuario logeado...");
});
/*****/


var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.set('aliveGtws', aliveGtws);

// uncomment after placing your favicon in /public
app.use(favicon(__dirname + '/public/images/favicon.ico'));

// AGL.. Clear Update folder
require('del').sync(['./uploads/**', '!./uploads']);

// to updload files
var multer = require('multer');
app.post('/', [
    multer({
        dest: './uploads/'
    }).single('upl'),
    function (req, res) {
        logging.LoggingDate(req.file); //form files
        var retorno = {};
        //Inicializar el campo
        fs.readFile(req.file.path, 'utf8', function (err, contents) {
            myLibConfig.checkExportGtwNamesOrIpDup(req.body.config, req.body.site, JSON.parse(contents), function (result) {
                if (result.data == 'OK') {
                    logging.LoggingSuccess('Comprobación de importación correcta');
                    myLibConfig.postConfigurationFromJsonFile(req.body.config, req.body.site, JSON.parse(contents), function (result) {
                        if (result.error == null) {
                            retorno.msg = 'Configuracion importada correctamente';
                            logging.LoggingSuccess('Configuracion importada correctamente');
                        }
                        else {
                            retorno.err = req.file.message;
                            logging.loggingError(req.file.message);
                        }
                        res.json(retorno);
                    });
                }
                else {
                    if (result.data == 'DUPLICATED') {
                        //alertify.error('Configuracion no importada. La pasarela (nombre o ips) ya existe en la configuración. ' +
                        //	'Elimine la pasarela o cambie los datos antes de importar.');
                        logging.loggingError('Configuracion no importada. La pasarela (nombre o ips) ya existe en la configuración. ' +
                            'Elimine la pasarela o cambie los datos antes de importar');
                        retorno.err = 'Configuracion no importada. La pasarela (nombre o ips) ya existe en la configuración. ' +
                            'Elimine la pasarela o cambie los datos antes de importar';
                    }
                    else {
                        //alertify.error('Configuracion no importada. Error en la operación.');
                        logging.loggingError('Configuracion no importada. Error en la operación.');
                        retorno.err = 'Configuracion no importada. Error en la operación.';
                    }
                    res.json(retorno);
                }
            });

            /*/  console.log(contents);
            myLibConfig.postConfigurationFromJsonFile(req.body.config, req.body.site, JSON.parse(contents),function(result){
                if (result.error == null){
                    myLibHardwareGateways.setResources(result.slaves,JSON.parse(contents).recursos,function(result){
                        logging.LoggingSuccess('Configuracion importada correctamente');
                        res.render('imported', {
                            dataToRestore:{
                                user: req.body.user,
                                clave: req.body.clave,
                                perfil: req.body.perfil,
                                LoginTimeout: config.Ulises.LoginTimeOut,
                                Region: config.Ulises.Region,
                                BackupServiceDomain: config.Ulises.BackupServiceDomain,
                                config: req.body.config,
                                site: req.body.site,
                                cfgData: req.body.cfgData
                            },
                            error: '',
                            message: 'Configuracion importada correctamente',
                            file: req.file.originalname
                        });
                    });
                }
                else if (result.error == -1){
                    logging.loggingError('Configuracion no importada. La pasarela ya existe. Elimine la pasarela antes de importar');
                    res.render('imported', {
                        dataToRestore:{
                            user: req.body.user,
                            clave: req.body.clave,
                            perfil: req.body.perfil,
                            LoginTimeout: config.Ulises.LoginTimeOut,
                            Region: config.Ulises.Region,
                            BackupServiceDomain: config.Ulises.BackupServiceDomain,
                            config: req.body.config,
                            site: req.body.site,
                            cfgData: req.body.cfgData
                        },
                        error: req.file.message,
                        message: 'Configuracion no importada. La pasarela ya existe. Elimine la pasarela antes de importar',
                        file: req.file.originalname
                    });                        
                }
                else{
                    logging.loggingError(req.file.message);
                    res.render('imported', {
                        dataToRestore:{
                            user: req.body.user,
                            clave: req.body.clave,
                            perfil: req.body.perfil,
                            LoginTimeout: config.Ulises.LoginTimeOut,
                            Region: config.Ulises.Region,
                            BackupServiceDomain: config.Ulises.BackupServiceDomain,
                            config: req.body.config,
                            site: req.body.site,
                            cfgData: req.body.cfgData
                        },
                        error: req.file.message,
                        message: 'Configuracion no importada',
                        file: req.file.originalname
                    });                        
                }
            });*/
        });
        //res.json({size:req.file.size});
        //res.status(200).redirect('/');
    }
]);

// create a write stream (in append mode)
//var accessLogStream = fs.createWriteStream(__dirname + '/access.log', {flags: 'a'})
//app.use(logger('dev', {stream: accessLogStream}));

// app.use(logger('dev'));
app.use(bodyParser.json());                                 // to support JSON-encoded bodies
app.use(bodyParser.urlencoded({ extended: false }));        // to support URL-encoded bodies
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

/** 20170525. AGL. Para el control de Sesiones. */
/** Para el control de Sesiones. */
var login_timeout = config.Ulises.LoginTimeOut == 0 ? 60000 : config.Ulises.LoginTimeOut * 60000;
app.use(require('express-session')(
    {
        secret: 'clave-secreta', resave: false, saveUninitialized: false,
        cookie: { maxAge: login_timeout }
    }));
app.use(flash());
// Initialize Passport and restore authentication state, if any, from the
// session.
app.use(passport.initialize());
app.use(passport.session());

// AGL. Mensajes para la pantalla login
function msg4Login(req, msg) {
    if (msg) {
        global.msg = msg;
        req.flash('error', msg);
    }
    else {
        var flash_msg = req.flash('error');
        // console.log("<" + arguments.callee.caller.name.toString() + ">: " + 'flash: ' + flash_msg);
        if (flash_msg.length == 0) {
            flash_msg = global.msg;
            delete global.msg;
            // console.log("<" + arguments.callee.caller.name.toString() + ">: " + 'global.msg: ' + flash_msg);
        }
        return flash_msg;
    }
}

//
var isAuthenticated = function (req, res, next) {
    if (ctrlSesiones.localSession != null && req.isAuthenticated()) {
        return next();
    }
    // console.log('redirect to /login from isAuthenticated');
    res.redirect('/login');
}

/* GET home page. */
app.get('/',
    //require('connect-ensure-login').ensureLoggedIn(),
    isAuthenticated,
    function (req, res, next) {
        logging.LoggingDate('app.get</> IN');
        res.render('index',
            {
                LoginTimeout: config.Ulises.LoginTimeOut,
                Region: config.Ulises.Region,
                BackupServiceDomain: config.Ulises.BackupServiceDomain,
                Version: config.Ulises.Version,
                user: (req.user ? req.user : { name: 'noname', perfil: 64 }),
                session: ctrlSesiones.localSession
            });
        logging.LoggingDate('app.get</> OUT');
    });

app.get('/login',
    function (req, res) {
        logging.LoggingDateCond('app.get</login>: ', config.Ulises.LoginSystemTrace);
        //    res.render('login', {message: req.flash('error'), region: config.Ulises.Region});
        res.render('login', { message: msg4Login(req), region: config.Ulises.Region });
    });

app.post('/login',
    passport.authenticate('local', { failureRedirect: '/login', failureFlash: true }),
    function (req, res) {
        logging.LoggingDateCond('app.post</login>: ' + req.user.name + ' ' + req.user.perfil, config.Ulises.LoginSystemTrace);
        ctrlSesiones.localSession = req.session;
        ctrlSesiones.localSession.lastTick = moment();
        res.redirect('/');
    });

app.get('/logout',
    function (req, res) {
        logging.LoggingDateCond('app.get</logout>: ' + req.user.name + ' ' + req.user.perfil, config.Ulises.LoginSystemTrace);
        insertHistoric(USER_LOGOUT_SYSTEM, ctrlSesiones.user.name, '');
        ctrlSesiones.localSession = null;
        req.logout();
        res.redirect('/');
    });

/** 20170808 AGL. TICK de Sesion Activa */
app.get('/alive',
    //  isAuthenticated,
    function (req, res, next) {

        if (ctrlSesiones.localSession) {
            ctrlSesiones.localSession.lastTick = moment();
        }

        if (req.isAuthenticated()) {
            res.json({ alive: "ok" });
        }
        else {
            msg4Login(req, 'La sesion ha expirado. Identifiquese de nuevo');

            // console.log('redirect to /login from /alive');

            res.redirect('/login');
        }
    });

/** 20070908 AGL. Para Leer / Escribir la configuracion local del servidor */
app.get('/localconfig',
    isAuthenticated,
    function (req, res, next) {
        res.json(config.Ulises);
    });

/** */
var Ajv = require('ajv');
var ajv = Ajv({ AllErrors: true });

var validateLocalConfig = ajv.compile(
    {
        "properties": {
            "BackupServiceDomain": { "type": "string" },
            "Date": { "type": "string" },
            "Files": { "items": {}, "type": "array" },
            "HistoricsDeep": { "type": "integer" },
            "LoginSystemTrace": { "type": "boolean" },
            "LoginTimeOut": { "type": "integer" },
            "MySQL": { "type": "string" },
            "NodeJS": { "type": "string" },
            "Region": { "type": "string" },
            "SubVersion": { "type": "string" },
            "Version": { "type": "string" },
            "dbdatabase": { "type": "string" },
            "dbhost": { "type": "string" },
            "dbpassword": { "type": "string" },
            "dbuser": { "type": "string" },
            "log2con": { "type": "string" },
            "log2file": { "type": "string" },
            "logfile_maxfiles": { "type": "integer" },
            "logfile_path": { "type": "string" },
            "logfile_sizefile": { "type": "integer" },
            "maxCycleTime": { "type": "integer" },
            "morgan": { "type": "boolean" },
            "refreshTime": { "type": "integer" }
        },
        "required": [
            "LoginTimeOut", "morgan", "logfile_sizefile", "SubVersion", "dbhost",
            "logfile_path", "logfile_maxfiles", "log2file", "BackupServiceDomain",
            "Region", "maxCycleTime", "log2con", "dbuser", "Date", "dbpassword",
            "refreshTime", "NodeJS", "Files", "HistoricsDeep", "dbdatabase",
            "Version", "MySQL", "LoginSystemTrace"
        ]
    });

app.post('/localconfig',
    isAuthenticated,
    function (req, res) {
        // console.log(req.body);

        // Chequear coherencia.
        if (validateLocalConfig(req.body)) {
            // Lo salvo en los datos...
            config.Ulises = req.body;
            // Lo salvo en el fichero...
            var Ulises = { Ulises: req.body };
            fs.writeFile("./configUlises.json", JSON.stringify(Ulises, null, 2), function (err) {
                if (err) res.json({ res: false, txt: 'Error fs.writeFile' });
                else {
                    res.json({ res: true, txt: 'File saved.' });
                    logging.Configure(Ulises.Ulises);
                }
            });
        }
        else {
            res.json({ res: false, txt: 'JSON no valido...' });
        }
    });

app.use('/users', isAuthenticated, users);
app.use('/gateways', gateways);
app.use('/configurations', configurations);
app.use('/services', isAuthenticated, services);
app.use('/hardware', isAuthenticated, hardware);
app.use('/resources', isAuthenticated, resources);
app.use('/sites', isAuthenticated, sites);
app.use('/destinations', isAuthenticated, radioDestinations);
app.use('/historics', isAuthenticated, historics);
app.use('/version', isAuthenticated, version);
app.use('/tableBss', isAuthenticated, tableBss);
app.use('/externalResources', isAuthenticated, externalResources);
app.use('/hrr', isAuthenticated, hrr);

// app.use('/', routes);
// app.use('/users', users);
// app.use('/gateways', gateways);
// app.use('/configurations', configurations);
// app.use('/services', services);
// app.use('/hardware',hardware);
// app.use('/resources',resources);
// app.use('/sites', sites);
// app.use('/destinations',radioDestinations);
// app.use('/historics',historics);
// app.use('/version',version);
// app.use('/tableBss',tableBss);
/*********************************/

// catch 404 and forward to error handler
app.use(function (req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function (err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function (err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {}
    });
});

/*function synchGateways() {
	v
	setTimeout(function(){synchGateways()},config.Ulises.refreshTime);
}*/

// Prepare historics deep
setImmediate(function () {
    logging.LoggingDate('Running once a day. Historics deep: ' + config.Ulises.HistoricsDeep + ' days.');
    myLibHistorics.deepHistorics(config.Ulises.HistoricsDeep, function (result) {
        logging.LoggingDate('Historics record removed: ' + result.affectedRows + ', ' + result.error);
    });
    myLibConfig.resetGatewaysSynchroState(function (result) {
        logging.LoggingDate('Reset Gateways Synchro State: ' + result.result);
    });
});

setInterval(function () {
    logging.LoggingDate('Running once a day. Historics deep: ' + config.Ulises.HistoricsDeep + ' days.');
    //logging.LoggingDate('[' + new Date().toString() + ']' + 'Running once a day. Historics deep: ' + config.Ulises.HistoricsDeep + ' days.');
    myLibHistorics.deepHistorics(config.Ulises.HistoricsDeep, function (result) {
        logging.LoggingDate('Historics record removed: ' + result.affectedRows);
        //logging.LoggingDate('[' + new Date().toString() + ']' + 'Historics record removed: ' + result.affectedRows);
    });
}, 86400000);

/** 20170525. AGL. Para el control de Sesiones. */
var intervalObject = setInterval(function () {
    if (ctrlSesiones.localSession) {
        if (moment().diff(ctrlSesiones.localSession.lastTick, "seconds") > 60) {
            logging.LoggingDateCond("La Session ha expirado...El cliente no genera los ticks", config.Ulises.LoginSystemTrace);
            insertHistoric(USER_LOGOUT_SYSTEM, ctrlSesiones.user.name, 'La Session ha expirado...El cliente no genera los ticks.');
            ctrlSesiones.localSession = null;
        }
        else if (moment().isAfter(moment(ctrlSesiones.localSession.cookie._expires))) {
            logging.LoggingDateCond("La Session ha expirado....", config.Ulises.LoginSystemTrace);
            insertHistoric(USER_LOGOUT_SYSTEM, ctrlSesiones.user.name, 'La Session ha expirado....');
            ctrlSesiones.localSession = null;
        }
    }
    logging.LoggingDateCond(moment().toString() + ": " +
        (ctrlSesiones.localSession ? ("Sesion Activa hasta : " + moment(ctrlSesiones.localSession.cookie._expires).toString()) : "No Session"), config.Ulises.LoginSystemTrace);
    //  console.log(config.Ulises.LoginSystemTrace);
}, 5000);

var synch = setInterval(function () {
    var maxCycleTime = config.Ulises.maxCycleTime;
    for (var i = 0; i < aliveGtws.length; i++) {
        if (aliveGtws[i].online == true) {
            aliveGtws[i].time = (aliveGtws[i].time + parseInt(config.Ulises.refreshTime));
            if (aliveGtws[i].time >= maxCycleTime) {
                aliveGtws[i].online = false;
                aliveGtws[i].isSinch = false;
            }
        }
        else
            aliveGtws[i].isSinch = false;
    }
	/*logging.LoggingDate('Tick. Pasarelas='+aliveGtws.length);
	if(aliveGtws.length>0){
	    logging.LoggingDate(aliveGtws[0].time);
	    logging.LoggingDate(aliveGtws[0].online);
    }*/
}, config.Ulises.refreshTime);
/*************************/

fs.watchFile(require.resolve('./configUlises.json'), function () {
    /** Para cargar dinamicamente los cambios de configuracion */
    delete require.cache[require.resolve('./configUlises.json')];
    config = require('./configUlises.json');
    console.log('Configuracion cambiada...');
});

app.set('port', process.env.PORT || 5050);

//Variable para usuario ya conectado
app.locals.isAuthenticated = false;
app.locals.AuthenticatedUser = 'none';

app.listen(app.get('port'), function () {
    logging.LoggingDate('Listening UG5k-Serv on port ' + app.get('port'));
    logging.LoggingDate('Express started in ' + app.get('env'));
});

module.exports = app;

process.on('uncaughtException', function (err) {
    console.log('Caught exception: ' + err);
    logging.loggingError('Caught exception: ' + err);
}); 
