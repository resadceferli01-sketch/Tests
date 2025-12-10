using Microsoft.EntityFrameworkCore;
using ORM_EFcore.DAL;
using ORM_EFcore.Models;

class Program
{
    static void Main()
    {
        while (true)
        {
            Console.Clear();
            Console.WriteLine("===== MENU =====");
            Console.WriteLine("1. Student CRUD");
            Console.WriteLine("2. Group CRUD");
            Console.WriteLine("3. Teacher CRUD");
            Console.WriteLine("0. Exit");
            Console.Write("Choose: ");

            string choice = Console.ReadLine();

            switch (choice)
            {
                case "1": StudentMenu(); break;
                case "2": GroupMenu(); break;
                case "3": TeacherMenu(); break;
                case "0": return;
                default: Console.WriteLine("Wrong input!"); break;
            }

            Console.WriteLine("Press any key...");
            Console.ReadKey();
        }
    }

    // ========================= STUDENT MENU =========================
    static void StudentMenu()
    {
        Console.Clear();
        Console.WriteLine("1. Add Student");
        Console.WriteLine("2. List Students");
        Console.WriteLine("3. Delete Student");
        Console.Write("Choose: ");

        string choice = Console.ReadLine();

        switch (choice)
        {
            case "1": AddStudent(); break;
            case "2": ListStudents(); break;
            case "3": DeleteStudent(); break;
                case "0": return;
        }
    }

    static void AddStudent()
    {
        using (AppDbContext context = new AppDbContext())
        {
            Console.Write("Full name: ");
            string name = Console.ReadLine();

            Console.Write("Age: ");
            int age = int.Parse(Console.ReadLine());

            Console.Write("GroupId: ");
            int groupId = int.Parse(Console.ReadLine());

            var st = new Student
            {
                FullName = name,
                Age = age,
                GroupId = groupId
            };

            context.Students.Add(st);
            context.SaveChanges();

            Console.WriteLine("Student added.");
        }
    }
    static void ListStudents()
    {
        using (AppDbContext context = new AppDbContext())
        {
            var list = context.Students.Include(s => s.Group).ToList();

            foreach (var s in list)
                Console.WriteLine($"{s.Id}) {s.FullName} - {s.Age} - Group: {s.Group?.GroupName}");
        }
    }


    static void DeleteStudent()
    {
        using (AppDbContext context = new AppDbContext())
        {
            Console.Write("Student Id: ");
            int id = int.Parse(Console.ReadLine());

            var st = context.Students.FirstOrDefault(x => x.Id == id);
            if (st == null)
            {
                Console.WriteLine("Not found.");
                return;
            }

            context.Students.Remove(st);
            context.SaveChanges();
            Console.WriteLine("Deleted.");
        }
    }
    // ========================= GROUP MENU =========================
    static void GroupMenu()
    {
        Console.Clear();
        Console.WriteLine("1. Add Group");
        Console.WriteLine("2. List Groups");
        Console.WriteLine("3. Delete Group");
        Console.Write("Choose: ");

        string choice = Console.ReadLine();

        switch (choice)
        {
            case "1": AddGroup(); break;
            case "2": ListGroups(); break;
            case "3": DeleteGroup(); break;
        }
    }

    static void AddGroup()
    {
        using (AppDbContext context = new AppDbContext())
        {
            Console.Write("Group name: ");
            string name = Console.ReadLine();

            Console.Write("TeacherId: ");
            int teacherId = int.Parse(Console.ReadLine());

            var g = new Group { GroupName = name, TeacherId = teacherId };

            context.Groups.Add(g);
            context.SaveChanges();
            Console.WriteLine("Group added.");
        }
    }

    static void ListGroups()
    {
        using (AppDbContext context = new AppDbContext())
        {
            var list = context.Groups.Include(g => g.Teacher).ToList();

            foreach (var g in list)
                Console.WriteLine($"{g.Id}) {g.GroupName} - Teacher: {g.Teacher?.FullName}");
        }
    }




    static void DeleteGroup()
    {
        using (AppDbContext context = new AppDbContext())
        {
            Console.Write("Group Id: ");
            int id = int.Parse(Console.ReadLine());

            var g = context.Groups.FirstOrDefault(x => x.Id == id);
            if (g == null)
            {
                Console.WriteLine("Not found.");
                return;
            }

            context.Groups.Remove(g);
            context.SaveChanges();
            Console.WriteLine("Deleted.");
        }
    }

    // ========================= TEACHER MENU =========================
    static void TeacherMenu()
    {
        Console.Clear();
        Console.WriteLine("1. Add Teacher");
        Console.WriteLine("2. List Teachers");
        Console.WriteLine("3. Delete Teacher");
        Console.Write("Choose: ");

        string choice = Console.ReadLine();

        switch (choice)
        {
            case "1": AddTeacher(); break;
            case "2": ListTeachers(); break;
            case "3": DeleteTeacher(); break;
        }
    }

    static void AddTeacher()
    {
        using (AppDbContext context = new AppDbContext())
        {
            Console.Write("Full name: ");
            string name = Console.ReadLine();

            var t = new Teacher { FullName = name };

            context.Teachers.Add(t);
            context.SaveChanges();

            Console.WriteLine("Teacher added.");
        }
    }

    static void ListTeachers()
    {
        using (AppDbContext context = new AppDbContext())
        {
            var list = context.Teachers.Include(t => t.Groups).ToList();

            foreach (var t in list)
                Console.WriteLine($"{t.Id}) {t.FullName} - Groups: {t.Groups.Count}");
        }
    }


    static void DeleteTeacher()
    {
        using (AppDbContext context = new AppDbContext())
        {
            Console.Write("Teacher Id: ");
            int id = int.Parse(Console.ReadLine());

            var t = context.Teachers.FirstOrDefault(x => x.Id == id);
            if (t == null)
            {
                Console.WriteLine("Not found.");
                return;
            }

            context.Teachers.Remove(t);
            context.SaveChanges();
            Console.WriteLine("Deleted.");
        }
    }
}
