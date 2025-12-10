using System;
using System.Collections.Generic;
using System.Text;

namespace ORM_EFcore.Models
{
   public class Teacher
    {
        public int Id { get; set; }
        public string FullName { get; set; }

        public ICollection<Group> Groups { get; set; }
    }
}
