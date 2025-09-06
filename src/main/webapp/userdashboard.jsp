<%@ page import="com.shashi.DAO.UserDAO" %>
<%@ page import="com.shashi.DTO.User" %>
<%@ page import="java.sql.SQLException" %>

<%
// Check for valid session
String sessionId = null;
Cookie[] cookies = request.getCookies();
if (cookies != null) {
    for (Cookie cookie : cookies) {
        if (cookie.getName().equals("sessionId")) {
            sessionId = cookie.getValue();
            break;
        }
    }
}

User currentUser = null;
if (sessionId != null) {
    try {
        UserDAO userDao = new UserDAO();
        currentUser = userDao.getUserBySession(sessionId);
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

// Redirect to login if no valid session
if (currentUser == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Compile Zen</title>
    <link href="https://fonts.googleapis.com/css2?family=Fira+Code:wght@400;500&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #646cff;
            --primary-hover: #535bf2;
            --bg: #1a1a1a;
            --editor-bg: #282c34;
            --text: rgba(255, 255, 255, 0.87);
            --text-secondary: rgba(255, 255, 255, 0.6);
            --border: #444;
            --success: #4CAF50;
            --error: #f44336;
            --warning: #ff9800;
            --card-bg: #242424;
            --line-numbers: #636363;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            line-height: 1.5;
            background-color: var(--bg);
            color: var(--text);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 40px;
            background-color: rgba(0, 0, 0, 0.2);
            border-bottom: 1px solid var(--border);
        }

        .logo {
            font-size: 1.8rem;
            font-weight: 600;
            background: linear-gradient(90deg, var(--primary), #61dafb);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            text-decoration: none;
        }

        .btn {
            padding: 8px 20px;
            border-radius: 6px;
            font-family: 'Inter', sans-serif;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
            border: none;
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
            transform: translateY(-1px);
        }

        .btn-outline {
            background-color: transparent;
            color: var(--primary);
            border: 1px solid var(--primary);
        }

        .btn-outline:hover {
            background-color: rgba(100, 108, 255, 0.1);
        }

        .dashboard-container {
            padding: 60px 40px;
            max-width: 1200px;
            margin: 0 auto;
            flex-grow: 1;
            width: 100%;
        }

        .welcome-message h1 {
            font-size: 2.5rem;
            margin-bottom: 15px;
            background: linear-gradient(90deg, var(--primary), #61dafb);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .welcome-message p {
            color: var(--text-secondary);
            font-size: 1.1rem;
            margin-bottom: 30px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 1.1rem;
        }

        .user-nav {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 40px;
        }

        .feature-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 40px;
        }

        .feature-card {
            background-color: var(--card-bg);
            border-radius: 8px;
            padding: 25px;
            border: 1px solid var(--border);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }

        .feature-card h3 {
            color: var(--primary);
            margin-bottom: 15px;
        }

        .feature-card p {
            color: var(--text-secondary);
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 15px 20px;
            }
            
            .dashboard-container {
                padding: 40px 20px;
            }
            
            .feature-cards {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <a href="index.jsp" class="logo">Compile Zen</a>
        <div class="user-nav">
            <div class="user-avatar">
                <%= currentUser.getFullName().substring(0, 1).toUpperCase() %>
            </div>
            <form action="logout" method="POST">
                <button type="submit" class="btn btn-outline">Logout</button>
            </form>
        </div>
    </nav>

    <div class="dashboard-container">
        <div class="welcome-message">
            <h1>Welcome back, <%= currentUser.getFullName() %>!</h1>
            <p>You're logged in as <%= currentUser.getEmail() %></p>
        </div>

        <div class="action-buttons">
            <a href="editor.html" class="btn btn-primary">Go to Editor</a>
            <a href="projects.jsp" class="btn btn-outline">My Projects</a>
        </div>

        <div class="feature-cards">
            <div class="feature-card">
                <h3>Recent Projects</h3>
                <p>Access your recently worked on code projects and snippets.</p>
            </div>
            <div class="feature-card">
                <h3>Shared With You</h3>
                <p>View projects that other users have shared with you.</p>
            </div>
            <div class="feature-card">
                <h3>Templates</h3>
                <p>Start coding quickly with our pre-built templates.</p>
            </div>
        </div>
    </div>
</body>
</html>