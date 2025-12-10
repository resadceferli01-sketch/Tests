using Microsoft.EntityFrameworkCore;
using ORM_EFcore.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace ORM_EFcore.DAL
{
    public class AppDbContext : DbContext
    {
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer(Constants.Constants.URL);
            base.OnConfiguring(optionsBuilder);
        }

        public DbSet<Student> Students { get; set; }
        public DbSet<Teacher> Teachers { get; set; }

        public DbSet<Group> Groups { get; set; }
    }
}
