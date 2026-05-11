<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageNotFound.aspx.cs" Inherits="Society_management.PageNotFound" %>

<!DOCTYPE html>
<html>
<head>
    <title>Society Maintenance - Work in Progress</title>
    <style>
    :root { 
        --skin: #ffdbac; 
        --uniform: #1a5276; 
        --hat: #212f3d;
        --boots: #3e2723;
        --border-dark: #0d2b3e; 
    }

    body { 
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
        background: #f4f7f6; 
        display: flex; 
        flex-direction: column; 
        align-items: center; /* Centers container and text horizontally */
        justify-content: center; 
        height: 100vh; 
        margin: 0; 
        overflow: hidden;
    }

    /* Man Container - Centered Anchor */
    .man-container {
        position: relative;
        width: 200px;
        height: 300px; 
        margin: 0 auto;
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

    /* --- BODY (Centered Anchor) --- */
    .torso {
        position: absolute;
        top: 80px;
        left: 50%;
        transform: translateX(-50%);
        width: 70px;
        height: 95px;
        background: var(--uniform);
        border-radius: 10px;
        z-index: 7; /* Higher than left arm to keep it "inside" */
        box-shadow: inset 5px 0px 5px rgba(0,0,0,0.1);
    }

    /* --- ARMS --- */
    /* Left Arm: Tucked behind the Torso */
    .arm-left {
        position: absolute;
        top: 85px; 
        left: 53px; /* Adjusted to attach to torso side */
        width: 22px;
        height: 52px;
        border: 12px solid var(--uniform);
        border-right: 2px solid var(--border-dark); /* Dark border for visibility */
        border-top: 0;
        border-radius: 0 0 0 20px;
        z-index: 6; /* Lower than torso */
    }

    /* Right Arm: Active with Shoulder Joint */
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
        transform-origin: top center;
        border-radius: 10px;
        animation: shoulder-swing 2s infinite ease-in-out;
    }

    .forearm {
        position: absolute;
        top: 35px;
        width: 15px;
        height: 40px;
        background: var(--skin);
        border-radius: 10px;
        transform-origin: top center;
        animation: elbow-work 2s infinite ease-in-out;
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
    .leg.right { left: 103px; animation: leg-tap 1s infinite; }
    
    .boot {
        position: absolute;
        bottom: -8px;
        width: 35px;
        height: 15px;
        background: var(--boots);
        border-radius: 5px 10px 2px 2px;
    }
    .leg.left .boot { left: -5px; }
    .leg.right .boot { left: 0; }

    /* --- ANIMATIONS --- */
    @keyframes blink { 0%, 90%, 100% { transform: scaleY(1); } 95% { transform: scaleY(0.1); } }
    
    @keyframes breathe { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-5px); } }
    
    @keyframes shoulder-swing { 0%, 100% { transform: rotate(-25deg); } 50% { transform: rotate(10deg); } }
    
    @keyframes elbow-work { 0%, 100% { transform: rotate(40deg); } 50% { transform: rotate(100deg); } }
    
    @keyframes leg-tap { 0%, 100% { transform: rotate(0deg); } 50% { transform: rotate(-2deg); } }

    /* --- UI ELEMENTS --- */
    .content { text-align: center; margin-top: 20px; }
    
    h1 { color: var(--uniform); margin: 5px 0; font-size: 2.2rem; }
    
    p { color: #666; margin-bottom: 25px; font-size: 1.1rem; }
    
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
    
    .btn-back { background: #cfd8dc; color: #37474f; }
    
    .btn-home { background: var(--uniform); color: white; border: none; }
    
    .btn:hover { 
        transform: translateY(-3px); 
        box-shadow: 0 5px 15px rgba(0,0,0,0.1); 
    }
    @media (max-width: 768px) {
    .btn-group {
        width: 100%;
        max-width: 280px;
        margin: 0 auto;
        gap: 12px;
    }

    .btn,
    .btn-home,
    .btn-back {
        width: 100%;
        padding: 12px 18px;
        font-size: 16px;
        border-radius: 8px;
        box-sizing: border-box;
    }
}
</style>
</head>
<body>
    <form id="form1" runat="server">
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
            <h1>Under Maintenance</h1>
            <p>Our technician is fixing the society gates. Please wait a moment.</p>
            
            <div class="btn-group">
                <button type="button" class="btn btn-back" onclick="window.history.back();">← Go Back</button>
                
                <%-- Server-side button to handle dynamic redirect based on A_id or u_id --%>
                <asp:LinkButton ID="btnDynamicHome" runat="server" CssClass="btn btn-home" OnClick="btnDynamicHome_Click">Go Home</asp:LinkButton>
            </div>
        </div>
    </form>
</body>
</html>