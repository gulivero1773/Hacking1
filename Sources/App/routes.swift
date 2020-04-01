import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
 
    router.get("great", String.parameter) { req -> String in
        let name = try req.parameters.next(String.self)
        let age = try req.parameters.next(Int.self)
        return "Hello, \(name) and \(age)!"
    }
    router.post("tweet", String.parameter) { req -> String in
        let message = try req.parameters.next(String.self)
        return "Posting \(message)..."
    }
    router.post(Article.self, at: "article") { req, article -> String in
        return "Loaded article: \(article.title)"
    }
    router.get("users", User.parameter) { req -> String in
        let user = try req.parameters.next(User.self)
        return "Loaded user: \(user.username)"
    }

    router.group("admin") { group in
        group.get("edit") { req in
            return "Edit article."
        }
        group.get("new") { req in
            return "New article"
        }
    }
    
    router.group("article", Int.parameter) { group in
        group.get("read") { req -> String in
            let num = try req.parameters.next(Int.self)
            return "Reading article \(num)"
        }
    
        group.get("edit"){ req -> String in
            let num = try req.parameters.next(Int.self)
            return "Editting article \(num)"
        }
    }
    
    try router.register(collection: AdminCollection())
    
}


struct Article: Content {
    var title: String
    var content: String
}

struct User: Parameter {
    var username: String
    
    static func resolveParameter(_ parameter: String, on container: Container) throws -> User {
        return User(username: parameter)
    }
}

struct AdminCollection: RouteCollection {
    func boot(router: Router) throws {
        let article = router.grouped("article", Int.parameter)
    
        article.get("read") { req -> String in
            let num = try req.parameters.next(Int.self)
            return "Reading article \(num)"
        }
        article.get("edit") { req -> String in
            let num = try req.parameters.next(Int.self)
            return "Editing article \(num)"
        }
    }
}
/// HAcking
