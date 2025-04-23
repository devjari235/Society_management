<%@ Page Title="" Language="C#" MasterPageFile="~/H_master.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="Society_management.Home" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<style>
 
    /*.clean-section {
 background-image:url(Images\skyblue.png);

            color: #333;
        }
        .clean-section h2 {
            color: #2c3e50;
            font-weight: bold;
        }
        .clean-section p {
            color: #555;
        }

        .clean-section .container {*/
            /*background-color: #ecf0f1;*/
            /*padding: 50px 0;*/
            /*border-radius: 8px;
        }
        .clean-section .container h2 {
            color: #2980b9;
            font-weight: bold;
        }
        .clean-section .container p {
            color: #7f8c8d;
        }

        .clean-section img {
            border-radius: 8px;
        }
        .clean-section h4 {*/
            /*margin-top: 15px;*/
            /*color: #34495e;
        }
        .text-justify {
            text-align: justify;
        }*/
            section{
                background:url('Images/section.png');
            }
</style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <section>
        <img src="Images\S_1.png" class="img-fluid" style="max-height:300px;width:100%;"/>
    </section>

    <section class="clean-section">
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <center>
                        <h2>Our Features</h2>
                        <p><b>Our 3 Primary Features-</b></p>
                    </center>
                </div>
            </div>

            <div class="row">
                 <div class="col-md-4">
                     <center>
                         <img src="images\R_1.jpeg" width="150px" height="100px"/>
                     
                         <h4>Resident Management</h4>
                         <p class="text-justify">
                              Each profile includes contact information, flat number, ownership status, and move-in/move-out history.
                         </p>
                    </center>
                </div>

                 <div class="col-md-4">
                    <center>
                        <img src="images\Bill.png" width="100px" height="100px"/>
                      
                        <h4>Maintenance Billing</h4>
                        <p class="text-justify">
                             Automatically generate monthly maintenance invoices based on predefined rules (e.g., per square foot, flat rate, etc.).
                    </center>
                </div>

                 <div class="col-md-4">
                     <center>
                     <img src="images\Booking.jpg" width="170px" height="100px"/>
                     <h4>Facility Booking</h4>
                     <p class="text-justify">
                        Residents can view availability and book common society facilities such as the clubhouse, gym, garden area, or guest parking.
                    </center>
                </div>
            </div>
     </div>
    </section>

            <section>
                <img src="Images\S_2.jpg" class="img-fluid" style="max-height:350px;width:100%;"/>
            </section>

    <section class="clean-section">
    <div class="container">
        <div class="row">
            <div class="col-12">
                <center>
                    <h2>Our Process</h2>
                    <p><b>We have a Simple step Process-</b></p>
                </center>
            </div>
        </div>

        <div class="row">
             <div class="col-md-4">
                 <center>
                     <img src="images\C_1.jpeg" width="150px" height="100px"/>
                     <h4>Complaint Management</h4>
                     <p class="text-justify">
                        Residents can easily raise complaints or service requests related to plumbing, electricity, security, etc. The system assigns a tracking ID, notifies relevant staff, and updates the status in real time. 
                     </p>
                </center>
            </div>

             <div class="col-md-4">
                <center>
                    <img src="images\notice.png" width="150px" height="100px"/>
                    <h4>Notice Board</h4>
                    <p class="text-justify">
                         A digital notice board for sharing important announcements like meeting schedules, maintenance work, water supply interruptions, and event invitations.
                </center>
            </div>

             <div class="col-md-4">
                 <center>
                 <img src="images\security.jpg" width="150px" height="100px"/>
                 <h4>Security & Visitor Logs</h4>
                 <p class="text-justify">
                Guards or security staff can log visitor entries,exits,and purpose of visit via a mobile interface.This real-time log increases safety and transparency while allowing residents to receive notifications when a guest or delivery arrives.
                </center>
            </div>
        </div>
 </div>
</section>

</asp:Content>
