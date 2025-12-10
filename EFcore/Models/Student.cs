using System;
using System.Collections.Generic;
using System.Text;

namespace ORM_EFcore.Models
{
    public class Student
    {
        public int Id { get; set; }
        public string FullName { get; set; }
        public int Age { get; set; }

        public int GroupId { get; set; }
        public Group Group { get; set; }
    }
}
