using System;
using System.Collections.Generic;
using System.Text;

namespace ORM_EFcore.Models
{
   public class Group
    {
        public int Id { get; set; }
        public string GroupName { get; set; }

        public int? TeacherId { get; set; }
        public Teacher Teacher { get; set; }

        public ICollection<Student> Students { get; set; }
    }
}
