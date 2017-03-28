import { Runner, BaseServer, BaseRoute, ConsoleLogger, authenticateExpress } from "@<%= c.scope %>/<%= c.appNameKC %>"

// Mind, that the secret must be the same than the auth server uses!
const SECRET = process.env.JWT_SECRET

if (!SECRET) {
  throw({message: "JWT_SECRET environment variable is not defined, exiting."})
}

// The route handles unauthenticated users. Call if from the frontend when the user is not authenticated. So,
// this route requires the email field.
class UnauthenticatedExampleRoute extends BaseRoute {
  static create(route, expressRouter, logger) {
    expressRouter.get(route, (req, res, next) => {
      logger.debug("Serving " + route);
      new UnauthenticatedExampleRoute(route, logger).serve(req, res, next);
    });
  }

  // Just do it :)
  constructor(route, logger) { super(route, logger); }

  // The real work is here
  serve(req, res, next) {
    res.send({"result": "OK"});
  }
}

// An authenticated route. Requires JWT token set in the Authorization header. So, the passport takes the user identity
// and places it in req.user
class AuthenticatedExampleRoute extends BaseRoute {
  // A factory method: create the handler and binds to the provided route
  static create(route, expressRouter, logger) {
    // The route will be authenticated, and accepts all the roles (parameter is missing)
    const auth = authenticateExpress();
    expressRouter.get(route, auth, function(req, res, next) {
      logger.warn("Serving " + route);
      new AuthenticatedExampleRoute(route, logger).serve(req, res, next);
    });
  }

  // Just do it :)
  constructor(route, logger) { super(route, logger); }

  // The real work is here
  serve(req, res, next) {
    res.send({"result": `OK, user with email ${req.user.email} contacted the server.`});
  }
}

const logger = new ConsoleLogger()

// The real server
class Server extends BaseServer {
  constructor() {
    // Configure the app, and create the global routes
    super(SECRET, logger)
    // Register the individual route handlers with their routes. this.router comes from the base class.
    AuthenticatedExampleRoute.create('/auth-contact', this.expressRouter, this.logger);
    UnauthenticatedExampleRoute.create('/anonim-contact', this.expressRouter, this.logger);
  }
}

// Instantiate the server
var server = new Server();

// Put everything together: the server, the dirname that must be __dirname, the logger
Runner(server, __dirname, logger);
