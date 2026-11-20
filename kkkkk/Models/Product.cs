using System;
using System.Collections.Generic;

namespace kkkkk.Models;

public partial class Product
{
    public int ProductId { get; set; }

    public int SubcategoryId { get; set; }

    public int ManufacturerId { get; set; }

    public string ProductName { get; set; } = null!;

    public string? Description { get; set; }

    public string? Composition { get; set; }

    public decimal BasePrice { get; set; }

    public string? Image { get; set; }

    public virtual Manufacturer Manufacturer { get; set; } = null!;

    public virtual ICollection<StockItem> StockItems { get; set; } = new List<StockItem>();

    public virtual Subcategory Subcategory { get; set; } = null!;
}
