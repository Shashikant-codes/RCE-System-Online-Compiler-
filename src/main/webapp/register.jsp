<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Compile Zen</title>
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
            min-height: 100vh;
            display: flex;
            flex-direction: column;
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

        .auth-container {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-grow: 1;
            padding: 40px 20px;
        }

        .auth-card {
            background-color: var(--card-bg);
            border-radius: 8px;
            padding: 40px;
            width: 100%;
            max-width: 450px;
            border: 1px solid var(--border);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        }

        .auth-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .auth-header h1 {
            font-size: 2rem;
            margin-bottom: 10px;
            background: linear-gradient(90deg, var(--primary), #61dafb);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .auth-header p {
            color: var(--text-secondary);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--text);
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            background-color: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border);
            border-radius: 6px;
            color: var(--text);
            font-family: 'Inter', sans-serif;
            font-size: 1rem;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
        }

        .btn-submit {
            padding: 12px 20px;
            border-radius: 6px;
            font-family: 'Inter', sans-serif;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-block;
            width: 100%;
            font-size: 1rem;
            border: none;
            background-color: var(--primary);
            color: white;
        }

        .btn-submit:hover {
            background-color: var(--primary-hover);
            transform: translateY(-1px);
        }

        .auth-footer {
            text-align: center;
            margin-top: 20px;
            color: var(--text-secondary);
        }

        .auth-footer a {
            color: var(--primary);
            text-decoration: none;
        }

        .auth-footer a:hover {
            text-decoration: underline;
        }

        .error-message {
            color: var(--error);
            margin-bottom: 15px;
            text-align: center;
            padding: 10px;
            background-color: rgba(244, 67, 54, 0.1);
            border-radius: 6px;
            border-left: 4px solid var(--error);
        }

        .password-strength {
            margin-top: 5px;
            height: 5px;
            background-color: var(--border);
            border-radius: 3px;
            overflow: hidden;
        }

        .strength-meter {
            height: 100%;
            width: 0;
            background-color: var(--error);
            transition: width 0.3s, background-color 0.3s;
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 15px;
            }
            
            .auth-card {
                padding: 30px 20px;
            }
        }
        
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
        
    </style>
</head>
<body>
    <nav class="navbar">
        <a href="index.jsp" class="logo">Compile Zen</a>
        <div>
            <a href="login.jsp" class="btn btn-outline">Login</a>
        </div>
    </nav>

    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h1>Create Account</h1>
                <p>Start coding in seconds with your free account</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="error-message">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="register" method="POST" onsubmit="return validateForm()">
                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name" class="form-control" placeholder="Enter your name" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="Enter your email" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Enter password" required minlength="6" oninput="checkPasswordStrength()">
                    
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="••••••••" required minlength="6">
                </div>
                <div class="form-group">
                    <button type="submit" class="btn-submit">Create Account</button>
                </div>
            </form>

            <div class="auth-footer">
                <p>Already have an account? <a href="login.jsp">Sign in</a></p>
            </div>
            
        </div>
    </div>

    <script>
        function validateForm() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                alert('Passwords do not match');
                return false;
            }
            
            if (password.length < 6) {
                alert('Password must be at least 6 characters');
                return false;
            }
            
            return true;
        }

        function checkPasswordStrength() {
            const password = document.getElementById('password').value;
            const strengthMeter = document.getElementById('strengthMeter');
            let strength = 0;
            
            if (password.length > 0) strength += 1;
            if (password.length >= 6) strength += 1;
            if (/[A-Z]/.test(password)) strength += 1;
            if (/[0-9]/.test(password)) strength += 1;
            if (/[^A-Za-z0-9]/.test(password)) strength += 1;
            
            // Update the strength meter
            const width = strength * 20;
            strengthMeter.style.width = width + '%';
            
            // Change color based on strength
            if (strength <= 2) {
                strengthMeter.style.backgroundColor = 'var(--error)';
            } else if (strength <= 4) {
                strengthMeter.style.backgroundColor = 'var(--warning)';
            } else {
                strengthMeter.style.backgroundColor = 'var(--success)';
            }
        }
    </script>
</body>
</html>