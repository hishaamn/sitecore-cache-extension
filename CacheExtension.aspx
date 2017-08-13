<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CacheExtension.aspx.cs" Inherits="Sitecore.Custom.Cache.UX.CacheExtension" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sitecore | Cache Extension</title>
    <link href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet" />
    <link href="CacheAssets/main.css" rel="stylesheet"/>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
    <script type="text/javascript" src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
    <script src="https://www.w3schools.com/lib/w3.js"></script>
    <script>
        function setValue(e) {
            var cacheName = e.currentTarget.parentElement.getAttribute("data-cache-name");
            document.getElementById("CacheNameValue").value = cacheName;
        }
    </script>
</head>
<body>
<form id="search" method="post" runat="server">

    <div class="wrapper">
        <div class="menu-section">
            <img src="CacheAssets/logo.png" width="300px" style="float: left" />
            <a runat="server" onserverclick="RefreshButtonClick">
                <img src="CacheAssets/refresh.png" width="30px" class="c-refresh" style="float: right; margin-right: 150px; margin-top: 25px" />
            </a>
            <input class="c-search-box" name="q" type="text" size="40" placeholder="Search..." oninput="w3.filterHTML('#myTable', '.item', this.value)" />
            <div class="entries">
                <asp:Label runat="server" ID="Entries" style="float: right; margin-right: 30px; margin-top:25px; font-weight: bold; color: white"/>
                
            </div>
            <div class="entries">
                <asp:Label runat="server" ID="Size" style="float: right; margin-right: 30px; margin-top:25px; font-weight: bold; color: white"/>
                
            </div>
        </div>
        <hr />
        <table class="container" id="myTable">
            <thead>
            <tr>
                <th>
                    <h1>Cache Name (<%= this.Caches.Count %>)</h1>
                </th>
                <th>
                    <h1>Count</h1>
                </th>
                <th>
                    <h1>Size</h1>
                </th>
                <th>
                    <h1>Delta</h1>
                </th>
                <th>
                    <h1>Max Size</h1>
                </th>
                <th><asp:Button ID="ClearButton" runat="server" Text="Clear All" OnClick="ClearAllCache" class="myButton" /></th>                        
            </tr>
            </thead>
            <tbody>
            <input type="hidden" runat="server" id="CacheNameValue" />
            <% foreach (var cacheInfo in this.Caches)
               {
            %>
                <tr class="item">
                    <td><%= cacheInfo.CacheName %></td>
                    <td><%= cacheInfo.Count %></td>
                    <td><%= cacheInfo.Size %></td>
                    <td><%= cacheInfo.Delta %></td>
                    <td><%= cacheInfo.MaxSize %></td>
                    <td data-cache-name="<%= cacheInfo.CacheName %>">
                        <asp:Button ID="PerCacheButton" runat="server" OnClientClick="setValue(event)" Text="Clear" OnClick="Clear_OnClick" class="myButton" />
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</form>
</body>
</html>