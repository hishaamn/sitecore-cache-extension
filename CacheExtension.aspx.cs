using System;

namespace Sitecore.Custom.Cache.UX
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using Sitecore.Caching;
    using Sitecore.Diagnostics;
    using Sitecore.Reflection;
    using Sitecore.sitecore.admin;

    public partial class CacheExtension : AdminPage
    {
        public List<CacheExtensionInfo> Caches { get; set; }

        public class CacheExtensionInfo
        {
            public string CacheIndex { get; set; }

            public string CacheDelta { get; set; }

            public string CacheName { get; set; }

            public string Count { get; set; }

            public string Size { get; set; }

            public string Delta { get; set; }

            public string MaxSize { get; set; }
        }

        protected override void OnInit(EventArgs arguments)
        {
            Assert.ArgumentNotNull((object)arguments, "arguments");
            this.CheckSecurity(true);
            base.OnInit(arguments);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.Page.IsPostBack)
            {
                this.Caches = this.ResetCacheList();
            }
        }

        public void RefreshButtonClick(object sender, EventArgs args)
        {
            this.Caches = this.ResetCacheList();
        }

        public void ClearAllCache(object sender, EventArgs args)
        {
            foreach (ICacheInfo allCache in CacheManager.GetAllCaches())
            {
                allCache.Clear();
            }
            TypeUtil.ClearSizeCache();
            
            this.Caches = this.ResetCacheList();
        }

        private List<CacheExtensionInfo> ResetCacheList()
        {
            ICacheInfo[] allCaches = CacheManager.GetAllCaches();

            Array.Sort(allCaches, new CacheComparer());

            var caches = new List<CacheExtensionInfo>();

            foreach (var cacheInfo in allCaches)
            {
                string index1 = "size_" + cacheInfo.Id.ToShortID();

                long num = MainUtil.GetLong(this.Request.Form[index1], 0L);

                caches.Add(new CacheExtensionInfo
                {
                    CacheIndex = index1,
                    CacheName = cacheInfo.Name,
                    Count = cacheInfo.Count.ToString(),
                    Size = StringUtil.GetSizeString(cacheInfo.Size),
                    CacheDelta = cacheInfo.Size.ToString(),
                    MaxSize = StringUtil.GetSizeString(cacheInfo.MaxSize),
                    Delta = StringUtil.GetSizeString(cacheInfo.Size - num)
                });
            }

            var stats = CacheManager.GetStatistics();

            this.Size.Text = $"Size: {stats.TotalSize}";
            this.Entries.Text = $"Entries: {stats.TotalCount}";

            return caches;
        }

        protected void Clear_OnClick(object sender, EventArgs e)
        {
            var cacheName = this.CacheNameValue.Value;

            var cacheObj = CacheManager.GetAllCaches().FirstOrDefault(w => w.Name.Equals(cacheName));

            cacheObj?.Clear();

            this.Caches = this.ResetCacheList();
        }
    }
}