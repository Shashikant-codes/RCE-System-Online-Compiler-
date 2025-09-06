<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Compile Zen - Online Code Editor</title>
    <link href="https://fonts.googleapis.com/css2?family=Fira+Code:wght@400;500&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
   
        
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
        
        .auth-buttons {
            display: flex;
            gap: 15px;
        }
        
        .btn {
            padding: 8px 20px;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
        }
        
        .btn-primary {
            background-color: var(--primary);
            color: white;
            border: none;
        }
        
        .btn-outline {
            background-color: transparent;
            color: var(--primary);
            border: 1px solid var(--primary);
        }
        
        .hero {
            padding: 80px 40px;
            text-align: center;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .hero h1 {
            font-size: 3.5rem;
            margin-bottom: 20px;
            background: linear-gradient(90deg, var(--primary), #61dafb);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
        
        .hero p {
            font-size: 1.2rem;
            color: var(--text-secondary);
            max-width: 700px;
            margin: 0 auto 40px;
        }
        
        .footer {
        
            padding: 40px;
            text-align: center;
            border-top: 1px solid var(--border);
            color: var(--text-secondary);
        }
        
             :root {
            --primary: #646cff;
            --primary-hover: #535bf2;
            --bg: #1a1a1a;
            --text: rgba(255, 255, 255, 0.87);
            --text-secondary: rgba(255, 255, 255, 0.6);
            --border: #444;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <a href="index.jsp" class="logo">Compile Zen</a>
        <div class="auth-buttons">
            <a href="login.jsp" class="btn btn-outline">Login</a>
            <a href="register.jsp" class="btn btn-primary">Register</a>
        </div>
    </nav>

    <section class="hero">
        <h1>Code. Compile. Create.</h1>
        <p>A powerful online code editor with support for multiple programming languages. Write, run, and share code right from your browser.</p>
        <a href="login.jsp" class="btn btn-primary">Start Coding Now</a>
    </section>

    <footer class="footer">
        <p>&copy; 2025 Compile Zen. All rights reserved.</p>
    </footer>
</body>
</html>