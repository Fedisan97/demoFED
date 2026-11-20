using Avalonia.Controls;
using Avalonia.Interactivity;
using kkkkk.Context;
using kkkkk.Models;
using System.Linq;

namespace kkkkk;

public partial class MainWindow : Window
{
    public MainWindow()
    {



        InitializeComponent();
    }

    private void Enter_Click(object? sender, RoutedEventArgs e)
    {var context = new ParanchevContext();            
        var user = context.Users.Where(x => x.Login == LoginBox.Text).FirstOrDefault();
        
        
        if (user != null)
        {
            var win = new CatalogWindow(user);
            win.Show();
            Close();
        }
    
        
        else
        
        
        {
            ErrorText.Text = "ппользователь с таким логином не найден";
        
        
        }
    
    
    }

    
    private void Guest_Click(object? sender, RoutedEventArgs e)
    {
        var win = new CatalogWindow();
        
        win.Show();
        
        Close();
    }
}