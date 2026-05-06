<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ErrorPage.aspx.cs" Inherits="Society_management.ErrorPage" %>

<!DOCTYPE html>
<html>
<head>
    <title>System Error - Society Maintenance</title>
    <style>
    :root { 
        --skin: #ffdbac; 
        --uniform: #1a5276; 
        --hat: #212f3d;
        --boots: #3e2723;
        --warning: #f39c12;
    }

    body { 
        font-family: 'Segoe UI', sans-serif; 
        background: #2c3e50; 
        display: flex; 
        flex-direction: column; 
        align-items: center; /* Centers container and text horizontally */
        justify-content: center; 
        height: 100vh; 
        margin: 0; 
        color: white;
        overflow: hidden;
    }

    /* Flickering Light Effect - Centered */
    .light-glow {
        position: absolute;
        top: 10%;
        left: 50%;
        transform: translateX(-50%);
        width: 150px;
        height: 150px;
        background: rgba(241, 196, 15, 0.2);
        filter: blur(50px);
        border-radius: 50%;
        animation: flicker 2s infinite;
    }

    @keyframes flicker {
        0%, 19%, 21%, 23%, 25%, 54%, 56%, 100% { opacity: 1; }
        20%, 22%, 24%, 55% { opacity: 0.2; }
    }

    /* Centered Man Container */
    .man-container {
        position: relative;
        width: 200px;
        height: 300px; 
        margin: 0 auto; /* Ensures container is centered */
        animation: breathe 4s infinite ease-in-out;
    }

    /* --- HEAD & FACE (Centered) --- */
    .hat {
        position: absolute;
        top: 10px;
        left: 50%;
        transform: translateX(-50%);
        width: 60px;
        height: 20px;
        background: var(--hat);
        border-radius: 50px 50px 0 0;
        z-index: 10;
    }

    .face {
        position: absolute;
        top: 20px;
        left: 50%;
        transform: translateX(-50%);
        width: 50px;
        height: 60px;
        background: var(--skin);
        border-radius: 20px 20px 30px 30px;
        z-index: 9;
    }

    .eye {
        position: absolute;
        top: 25px;
        width: 6px;
        height: 6px;
        background: #333;
        border-radius: 50%;
        animation: blink 3s infinite;
    }
    .eye.left { left: 12px; }
    .eye.right { right: 12px; }

    .smile {
        position: absolute;
        bottom: 15px;
        left: 50%;
        transform: translateX(-50%);
        width: 14px;
        height: 7px;
        border: 2.5px solid #333;
        border-top: 0;
        border-radius: 0 0 15px 15px;
    }

    /* --- BODY (Centered) --- */
    .torso {
        position: absolute;
        top: 80px;
        left: 50%;
        transform: translateX(-50%);
        width: 70px;
        height: 95px;
        background: var(--uniform);
        border-radius: 10px;
        z-index: 7;
    }

    /* --- ARMS --- */
    /* Left Arm: Tucked inside */
    .arm-left {
        position: absolute;
        top: 85px;
        left: 53px; 
        width: 22px;
        height: 52px;
        border: 12px solid var(--uniform);
        border-right: 2px solid #0d2b3e;
        border-top: 0;
        border-radius: 0 0 0 20px;
        z-index: 6;
    }
    
    /* Thinking/Repairing Arm */
    .shoulder-joint {
        position: absolute;
        top: 80px;
        left: 120px;
        width: 25px;
        height: 25px;
        background: var(--uniform);
        border-radius: 50%;
        z-index: 8;
    }

    .shoulder-right {
        position: absolute;
        top: 5px;
        left: 5px;
        z-index: 8;
    }

    .upper-arm {
        width: 18px;
        height: 45px;
        background: var(--uniform);
        border-radius: 10px;
        transform: rotate(-20deg);
    }

    .forearm {
        position: absolute;
        top: 35px;
        width: 15px;
        height: 40px;
        background: var(--skin);
        border-radius: 10px;
        animation: scratch-head 2s infinite ease-in-out;
        transform-origin: top center;
    }
    
    .wrench {
        position: absolute;
        bottom: -15px;
        left: -12px;
        font-size: 28px;
        transform: rotate(-40deg);
    }

    /* --- LEGS --- */
    .leg {
        position: absolute;
        top: 170px;
        width: 25px;
        height: 75px;
        background: var(--uniform);
        z-index: 6;
    }
    .leg.left { left: 72px; }
    .leg.right { left: 103px; }

    .boot {
        position: absolute;
        bottom: -8px;
        width: 35px;
        height: 15px;
        background: var(--boots);
        border-radius: 5px 10px 2px 2px;
    }

    /* --- ANIMATIONS --- */
    @keyframes scratch-head {
        0%, 100% { transform: rotate(40deg); }
        50% { transform: rotate(60deg); }
    }
    @keyframes breathe { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-5px); } }
    @keyframes blink { 0%, 90%, 100% { transform: scaleY(1); } 95% { transform: scaleY(0.1); } }

    /* --- UI ELEMENTS --- */
    .content { text-align: center; margin-top: 20px; }
    h1 { color: var(--warning); font-size: 2.2rem; margin: 5px 0; }
    p { color: #bdc3c7; margin-bottom: 25px; font-size: 1.1rem; }

    .btn-group { display: flex; gap: 15px; justify-content: center; }
    .btn {
        padding: 12px 25px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: bold;
        cursor: pointer;
        border: none;
        transition: 0.3s;
        display: inline-block;
    }
    .btn-back { background: #34495e; color: #ecf0f1; }
    .btn-home { background: var(--warning); color: #2c3e50; }
    .btn:hover { 
        transform: translateY(-3px); 
        box-shadow: 0 5px 15px rgba(0,0,0,0.3); 
    }
</style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="light-glow"></div>
        
        <div class="man-container">
            <div class="hat"></div>
            <div class="face">
                <div class="eye left"></div>
                <div class="eye right"></div>
                <div class="smile"></div>
            </div>
            <div class="arm-left"></div> 
            <div class="shoulder-joint">
                <div class="shoulder-right">
                    <div class="upper-arm">
                        <div class="forearm">
                            <div class="wrench">🔧</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="torso"></div>
            <div class="leg left"><div class="boot"></div></div>
            <div class="leg right"><div class="boot"></div></div>
        </div>

        <div class="content">
            <h1>Society System Error</h1>
            <p>Looks like a fuse blown in our server room. <br>Our technician is investigating the spark.</p>
            
            <div class="btn-group">
                <button type="button" class="btn btn-back" onclick="window.history.back();">← Go Back</button>
                <asp:LinkButton ID="btnDynamicHome" runat="server" CssClass="btn btn-home" OnClick="btnDynamicHome_Click">Go Home</asp:LinkButton>
            </div>
        </div>
    </form>
</body>
</html>