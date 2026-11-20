using Avalonia.Controls;
using Avalonia.Interactivity;
using kkkkk.Context;
using kkkkk.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;

namespace kkkkk;

public partial class CatalogWindow : Window
{
    private User _user;
    private List<ProductCard> _allCards = new List<ProductCard>();

    public CatalogWindow()
    {
        InitializeComponent();
        FioBox.Text = "гость";
        SearchBox.IsVisible = false;
        SortBox.IsVisible = false;
        FilterBox.IsVisible = false;
        LoadCards();
    }

    public CatalogWindow(User user)
    {
        InitializeComponent();
        _user = user;
        
        FioBox.Text = user.LastName + " " + user.FirstName + " " + user.MiddleName;
        LoadCards();
    }

    private void LoadCards()
    {
        var context = new ParanchevContext();
        var check = new DateOnly(2027, 1, 15);
        var start = new DateOnly(check.Year, check.Month, 1).AddMonths(-1);
        
        
        var end = start.AddMonths(1).AddDays(-1);
        var soldIds = context.OrderItems
        
            .Where(oi => oi.Order.OrderDate >= start && oi.Order.OrderDate <= end)
            .Select(oi => oi.StockItem.ProductId)
            .Distinct()
            .ToList();

        
        var products = context.Products
            .Include(p => p.Subcategory).ThenInclude(s => s.Category)
            .Include(p => p.Manufacturer)
            .Include(p => p.StockItems)
            .ToList();

                 _allCards = new List<ProductCard>();

        foreach (var p in products)
                       {


            var card = new ProductCard();
            card.ProductId = p.ProductId;
            card.ProductName = p.ProductName;
            card.CategoryName = p.Subcategory.Category.CategoryName;
            card.ManufacturerName = p.Manufacturer.ManufacturerName;
            card.Composition = p.Composition;
            card.Description = p.Description;
            card.BasePrice = p.BasePrice;

            switch (soldIds.Contains(p.ProductId))
                                  {
                
                
                case true:
                    card.DisplayPrice = p.BasePrice;
                    card.PriceText = $"{p.BasePrice:0.##} руб.";
                    break;
                
                
                case false:
                    card.DisplayPrice = p.BasePrice * 0.75m;
                    card.PriceText = $"{p.BasePrice:0.##} → {card.DisplayPrice:0.##} руб.";
                    break;



                                     }

            card.TotalCount = p.StockItems.Sum(s => s.Quantity);

            switch (card.TotalCount > 5)
             {
               
                case true:
                    card.CountText = "много";
                    break;
                
                
                case false:
                    card.CountText = "мало";
                    break;
             }

            switch (card.TotalCount <= 3)
            {
                case true:
                card.CardColor = "#FF8080";
                break;
                case false:
                card.CardColor = "#F6EEDC";
                break;
            }

            _allCards.Add(card);
        }

        var cats = new List<string>();
        cats.Add("все категории");
        cats.AddRange(context.Categories.Select(c => c.CategoryName).ToList());
        FilterBox.ItemsSource = cats;
        FilterBox.SelectedIndex = 0;
        SortBox.SelectedIndex = 0;

        ProductList.ItemsSource = _allCards;
    }

    private void RefreshList()
    {
        if  (SearchBox == null || SortBox == null || FilterBox == null || ProductList == null)
           
            
            return;

        var list = new List<ProductCard>(_allCards);

        switch (FilterBox.SelectedIndex)
        {
            case 0:
            break;


            default:
                var cat = FilterBox.SelectedItem.ToString();
                list = list.Where(x => x.CategoryName == cat).ToList();
                break;
        }

        var q = SearchBox.Text;
        if (q == null)
            q = "";
        q = q.ToLower();

        switch (q)
        {
            case "":
                break;
           
            
            default:
                list = list.Where(x => x.ProductName.ToLower().Contains(q) || x.Description.ToLower().Contains(q)).ToList();
                break;
        }

        switch (SortBox.SelectedIndex)
        {
            case 0:
                break;


            case 1:
                list = list.OrderBy(x => x.DisplayPrice).ToList();
                break;


            case 2:
                list = list.OrderByDescending(x => x.DisplayPrice).ToList();
                break;
        }

        ProductList.ItemsSource = list;
    }

    private void SearchBox_KeyUp(object? sender, Avalonia.Input.KeyEventArgs e)
    {
        RefreshList();
    }

    private void SortBox_SelectionChanged(object? sender, SelectionChangedEventArgs e)
    {
        RefreshList();
    }

    private void FilterBox_SelectionChanged(object? sender, SelectionChangedEventArgs e)
    {
        RefreshList();
    }

    private void Back_Click(object? sender, RoutedEventArgs e)
    {
        var win = new MainWindow();
        win.Show();
        Close();
    }
}