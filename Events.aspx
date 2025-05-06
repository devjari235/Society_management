<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Events.aspx.cs" Inherits="Society_management.Events" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        .event-card {
            transition: all 0.3s ease;
            border-radius: 10px;
            overflow: hidden;
            margin-bottom: 20px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .event-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
        }
        
        .event-live {
            border-left: 5px solid #28a745;
        }
        
        .event-upcoming {
            border-left: 5px solid #17a2b8;
        }
        
        .event-expired {
            border-left: 5px solid #6c757d;
            opacity: 0.8;
        }
        
        .event-image {
            height: 200px;
            object-fit: cover;
        }
        
        .status-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 0.8rem;
        }
        
        .calendar-day {
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .calendar-day:hover {
            background-color: #f8f9fa;
        }
        
        .day-with-events {
            background-color: #e9ecef;
            font-weight: bold;
        }
        
        #eventModal .modal-body {
            max-height: 70vh;
            overflow-y: auto;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="Dashboard.aspx">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">Event Management</li>
        </ol>
    </nav>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">Event Management</h2>
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createEventModal">
            <i class="fas fa-plus-circle"></i> Create New Event
        </button>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">Event Calendar</h5>
                </div>
                <div class="card-body">
                    <div id="eventCalendar"></div>
                </div>
            </div>
        </div>
        <div class="col-md-9">
            <ul class="nav nav-tabs" id="eventTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="live-tab" data-bs-toggle="tab" data-bs-target="#live" type="button">Live Events</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="upcoming-tab" data-bs-toggle="tab" data-bs-target="#upcoming" type="button">Upcoming</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="past-tab" data-bs-toggle="tab" data-bs-target="#past" type="button">Past Events</button>
                </li>
            </ul>
            <div class="tab-content p-3 border border-top-0 rounded-bottom" id="eventTabsContent">
                <div class="tab-pane fade show active" id="live" role="tabpanel">
                    <asp:Repeater ID="rptLiveEvents" runat="server">
                        <ItemTemplate>
                            <div class="card event-card event-live">
                                <span class="badge bg-success status-badge">Live</span>
                                <img src='<%# Eval("ImagePath") %>' class="card-img-top event-image" alt="Event Image">
                                <div class="card-body">
                                    <h5 class="card-title"><%# Eval("EventTitle") %></h5>
                                    <p class="card-text"><%# Eval("EventDescription") %></p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <small class="text-muted">
                                            <i class="fas fa-calendar-alt"></i> <%# Eval("StartDateTime", "{0:dd MMM yyyy hh:mm tt}") %> - 
                                            <%# Eval("EndDateTime", "{0:dd MMM yyyy hh:mm tt}") %>
                                        </small>
                                        <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-primary" 
                                            CommandArgument='<%# Eval("EventID") %>' OnClick="btnViewDetails_Click">
                                            View Details
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <div class="tab-pane fade" id="upcoming" role="tabpanel">
                    <!-- Upcoming Events -->
                    <asp:Repeater ID="rptUpcomingEvents" runat="server">
                        <ItemTemplate>
                            <div class="event-card">
                                <h4><%# Eval("EventTitle") %></h4>
                                <p><%# Eval("EventDescription") %></p>
                                <p><strong>Date:</strong> <%# Eval("StartDateTime", "{0:dd MMM yyyy hh:mm tt}") %></p>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>



                    <!-- Similar structure as live events -->
                </div>
                <div class="tab-pane fade" id="past" role="tabpanel">
                    <!-- Past Events -->
                    <asp:Repeater ID="rptPastEvents" runat="server">
                        <ItemTemplate>
                            <div class="event-card past">
                                <h4><%# Eval("EventTitle") %></h4>
                                <p><%# Eval("EventDescription") %></p>
                                <p><strong>Date:</strong> <%# Eval("StartDateTime", "{0:dd MMM yyyy hh:mm tt}") %></p>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <!-- Similar structure as live events -->
                </div>
            </div>
        </div>
    </div>

    <!-- Create Event Modal -->
    <div class="modal fade" id="createEventModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Create New Event</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="upCreateEvent" runat="server">
                        <ContentTemplate>
                            <div class="mb-3">
                                <label class="form-label">Event Title</label>
                                <asp:TextBox ID="txtEventTitle" runat="server" CssClass="form-control" required></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Description</label>
                                <asp:TextBox ID="txtEventDescription" runat="server" CssClass="form-control" 
                                    TextMode="MultiLine" Rows="3"></asp:TextBox>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Start Date & Time</label>
                                    <asp:TextBox ID="txtStartDateTime" runat="server" CssClass="form-control" 
                                        TextMode="DateTimeLocal" required></asp:TextBox>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">End Date & Time</label>
                                    <asp:TextBox ID="txtEndDateTime" runat="server" CssClass="form-control" 
                                        TextMode="DateTimeLocal" required></asp:TextBox>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Location</label>
                                <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Event Image</label>
                                <asp:FileUpload ID="fuEventImage" runat="server" CssClass="form-control" />
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <asp:Button ID="btnCreateEvent" runat="server" Text="Create Event" 
                        CssClass="btn btn-primary" OnClick="btnCreateEvent_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- Event Details Modal -->
    <div class="modal fade" id="eventDetailsModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="eventDetailTitle">Event Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="upEventDetails" runat="server">
                        <ContentTemplate>
                            <asp:HiddenField ID="hdnEventID" runat="server" />
                            <img id="imgEventDetail" src="" class="img-fluid mb-3" alt="Event Image" />
                            <p id="pEventDescription" class="mb-3"></p>
                            <div class="mb-3">
                                <strong>Date & Time:</strong>
                                <p id="pEventDateTime"></p>
                            </div>
                            <div class="mb-3">
                                <strong>Location:</strong>
                                <p id="pEventLocation"></p>
                            </div>
                            <div class="mb-3">
                                <strong>Status:</strong>
                                <span id="spanEventStatus" class="badge"></span>
                            </div>
                            <div class="mb-3" id="divAttendees" runat="server" visible="false">
                                <h6>Attendees</h6>
                                <asp:GridView ID="gvAttendees" runat="server" CssClass="table table-sm" AutoGenerateColumns="false">
                                    <Columns>
                                        <asp:BoundField DataField="MemberName" HeaderText="Name" />
                                        <asp:BoundField DataField="AttendanceStatus" HeaderText="Status" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn btn-primary" 
                        OnClick="btnRegister_Click" Visible="false" />
                    <asp:Button ID="btnCancelRegistration" runat="server" Text="Cancel Registration" 
                        CssClass="btn btn-danger" OnClick="btnCancelRegistration_Click" Visible="false" />
                    <asp:Button ID="btnDeleteEvent" runat="server" Text="Delete Event" 
                        CssClass="btn btn-danger" OnClick="btnDeleteEvent_Click" Visible="false" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.10.2/fullcalendar.min.js"></script>
    <script>
        $(document).ready(function () {
            // Initialize calendar
            $('#eventCalendar').fullCalendar({
                header: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'month,agendaWeek,agendaDay'
                },
                defaultDate: new Date(),
                navLinks: true,
                editable: false,
                eventLimit: true,
                events: {
                    url: 'EventManagement.aspx/GetCalendarEvents',
                    type: 'POST',
                    dataType: 'json',
                    contentType: 'application/json',
                    data: function () {
                        return JSON.stringify({});
                    }
                },
                eventClick: function (calEvent, jsEvent, view) {
                    // Handle event click to show details
                    __doPostBack('', 'VIEW_EVENT|' + calEvent.id);
                },
                dayRender: function (date, cell) {
                    // Highlight days with events
                    var events = $('#eventCalendar').fullCalendar('clientEvents', function (event) {
                        return moment(event.start).format('YYYY-MM-DD') == date.format('YYYY-MM-DD');
                    });
                    
                    if (events.length > 0) {
                        $(cell).addClass('day-with-events');
                    }
                }
            });

            // Validate date range
            $('#<%= txtEndDateTime.ClientID %>').change(function () {
                var startDate = new Date($('#<%= txtStartDateTime.ClientID %>').val());
                var endDate = new Date($(this).val());
                
                if (startDate >= endDate) {
                    alert('End date must be after start date');
                    $(this).val('');
                }
            });
        });

        function showEventDetails(title, description, start, end, location, image, status) {
            $('#eventDetailTitle').text(title);
            $('#pEventDescription').text(description);
            $('#pEventDateTime').text(moment(start).format('DD MMM YYYY hh:mm A') + ' - ' + moment(end).format('DD MMM YYYY hh:mm A'));
            $('#pEventLocation').text(location);
            $('#imgEventDetail').attr('src', image);
            
            var statusBadge = $('#spanEventStatus');
            statusBadge.text(status);
            
            if (status === 'Live') {
                statusBadge.addClass('bg-success').removeClass('bg-primary bg-secondary');
            } else if (status === 'Upcoming') {
                statusBadge.addClass('bg-primary').removeClass('bg-success bg-secondary');
            } else {
                statusBadge.addClass('bg-secondary').removeClass('bg-success bg-primary');
            }
            
            var modal = new bootstrap.Modal(document.getElementById('eventDetailsModal'));
            modal.show();
        }
    </script>
</asp:Content>
