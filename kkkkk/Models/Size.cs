using System;
using System.Collections.Generic;

namespace kkkkk.Models;

public partial class Size
{
    public int SizeId { get; set; }

    public int SizeValue { get; set; }

    public virtual ICollection<StockItem> StockItems { get; set; } = new List<StockItem>();
}
