<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="U_logout.aspx.cs" Inherits="Society_management.U_logout" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Logging Out...</title>
   <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    window.onload = function () {
        Swal.fire({
            icon: 'success',
            title: 'Logged Out',
            text: 'You have been successfully logged out.',
            confirmButtonText: 'OK'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = 'U_login.aspx';
            }
        });
    };

    history.pushState(null, null, location.href);
    window.onpopstate = function () {
        window.location.href = "U_login.aspx";
    };

    // Handle bfcache reload
    window.addEventListener("pageshow", function (event) {
        if (event.persisted || (window.performance && window.performance.navigation.type === 2)) {
            Swal.fire({
                icon: 'warning',
                title: 'Session Expired',
                text: 'Please login again.',
                confirmButtonText: 'OK'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = 'U_login.aspx';
                }
            });
        }
    });
</script>

</head>
<body>
    <form id="form1" runat="server">
    </form>
</body>
</html>
