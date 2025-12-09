using Microsoft.Data.SqlClient;


using System.Data;


namespace PizzaMizzaADO
{
    class Program
    {
        static string connectionString = @"Data Source=DESKTOP-KSNN651\SQLEXPRESS;Initial Catalog=PizzaMizzaDB;Integrated Security=True;Persist Security Info=False;Pooling=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=True;Application Name=""SQL Server Management Studio"";Command Timeout=0";

        static void Main(string[] args)
        {
            Console.OutputEncoding = System.Text.Encoding.UTF8;
            Console.InputEncoding = System.Text.Encoding.UTF8;
            while (true)
            {
                Console.WriteLine("===== Pizza Mizza Menyu =====");
                Console.WriteLine("1. Bütün pizzalara bax");
                Console.WriteLine("2. Yeni pizza yarat");
                Console.WriteLine("0. Cixis");
                Console.Write("Seçiminiz: ");

                string input = Console.ReadLine();
                Console.Clear();

                switch (input)
                {
                    case "1": ShowAllPizzas(); break;
                    case "2": CreatePizza(); break;
                    case "0": return;
                    default: Console.WriteLine("Yanlıs secim!"); break;
                }
            }
        }

        // ==================== 1 — Pizzaları göstər ====================
        static void ShowAllPizzas()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string cmdText = @"SELECT 
                                    P.Id, 
                                    P.Name, 
                                    PT.TypeName, 
                                    PP.Price 
                                FROM Pizzas AS P
                                INNER JOIN PizzaTypes AS PT ON P.TypeId = PT.Id
                                INNER JOIN PizzaPrices AS PP ON P.Id = PP.PizzaId
                                ORDER BY P.Id, P.Name, PT.TypeName, PP.Price";

                SqlCommand cmd = new SqlCommand(cmdText, conn);
                SqlDataReader reader = cmd.ExecuteReader();

                var pizzas = new Dictionary<string, List<string>>();

                while (reader.Read())
                {
                    string key = $"{reader["Id"]} | {reader["Name"]} | {reader["TypeName"]}";
                    string price = reader["Price"].ToString();

                    if (!pizzas.ContainsKey(key))
                        pizzas[key] = new List<string>();

                    pizzas[key].Add(price);
                }

                foreach (var item in pizzas)
                {
                    var parts = item.Key.Split('|');
                    string id = parts[0].Trim();
                    string name = parts[1].Trim();
                    string type = parts[2].Trim();

                    Console.WriteLine($"Pizza {id}");
                    Console.WriteLine($"  Adı: {name}");
                    Console.WriteLine($"  Tipi: {type}");
                    Console.WriteLine($"  Qiymətlər: {string.Join(" | ", item.Value)} ₼\n");
                }

                Console.Write("Pizza haqqında ətraflı məlumat üçün ID daxil edin (çıxmaq üçün 0): ");
                string input = Console.ReadLine();
                Console.WriteLine();

                if (int.TryParse(input, out int pizzaId) && pizzaId > 0)
                {
                   
                    ShowPizzaDetails(pizzaId);
                }
            }
        }
        public static void ShowPizzaDetails(int pizzaId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string cmdText = @"SELECT
                                    P.Id AS PizzaId,
                                    P.Name AS PizzaName,
                                    I.Name AS IngredientName,
                                    S.SizeName,
                                    PP.Price
                                FROM PizzaIngredients AS PI
                                INNER JOIN Ingredients AS I ON PI.IngredientId = I.Id
                                INNER JOIN Pizzas AS P ON PI.PizzaId = P.Id
                                INNER JOIN PizzaPrices AS PP ON P.Id = PP.PizzaId
                                INNER JOIN Sizes AS S ON S.Id = PP.SizeId
                                WHERE P.Id = @id
                                ORDER BY S.SizeName, I.Name";

                SqlCommand cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@id", pizzaId);
                SqlDataReader reader = cmd.ExecuteReader();

                bool hasRows = false;
                Console.WriteLine("-------------------------------------------------");
                while (reader.Read())
                {
                    hasRows = true;
                    Console.WriteLine($"Pizza ID: {reader["PizzaId"]}");
                    Console.WriteLine($"Adı: {reader["PizzaName"]}");
                    Console.WriteLine($"Ingredient: {reader["IngredientName"]}");
                    Console.WriteLine($"Ölçü: {reader["SizeName"]}");
                    Console.WriteLine($"Qiymət: {reader["Price"]} ₼");
                    Console.WriteLine();
                }
                Console.WriteLine("-------------------------------------------------");
                if (!hasRows)
                {
                    Console.WriteLine("Belə bir pizza tapılmadı.\n");
                }
            }

        }
        // ==================== 2 — Yeni Pizza yarat ====================
        static void CreatePizza()
        {
            Console.Write("Yeni pizzanın adını daxil edin: ");
            string name = Console.ReadLine();

            // Ingredient siyahısı
            var ingredients = new List<Ingredient>();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT Id, Name FROM Ingredients", conn);
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                    ingredients.Add(new Ingredient { Id = dr.GetInt32(0), Name = dr.GetString(1) });
            }

            Console.WriteLine("Ingredientlər: ");
            foreach (var ing in ingredients)
                Console.WriteLine($"{ing.Id}. {ing.Name}");

            Console.Write("Seçin (məs: 1,2,5): ");
            string ingredientInput = Console.ReadLine();
            string[] ingredientIds = ingredientInput.Split(',');

            // Ölçülər
            var sizes = new List<PizzaSize>();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT Id, SizeName FROM Sizes", conn);
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                    sizes.Add(new PizzaSize { Id = dr.GetInt32(0), Name = dr.GetString(1) });
            }

            Console.WriteLine("Ölçülər: ");
            foreach (var s in sizes)
                Console.WriteLine($"{s.Id}. {s.Name}");

            Console.Write("Ölçünü seçin: ");
            int sizeChoice = int.Parse(Console.ReadLine());

            Console.Write("Qiymət: ");
            decimal price = decimal.Parse(Console.ReadLine());

            int newPizzaId;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Pizza əlavə et

                SqlCommand cmdPizza = new SqlCommand(
           "INSERT INTO Pizzas(Name, TypeId) OUTPUT INSERTED.Id VALUES(@name, 4)", conn);
                cmdPizza.Parameters.AddWithValue("@name", name);

                newPizzaId = (int)cmdPizza.ExecuteScalar();

                // Ingredientlər əlavə et
                foreach (var ingId in ingredientIds)
                {
                    SqlCommand cmdPI = new SqlCommand(
                        "INSERT INTO PizzaIngredients(PizzaId, IngredientId) VALUES(@pId, @iId)", conn);
                    cmdPI.Parameters.AddWithValue("@pId", newPizzaId);
                    cmdPI.Parameters.AddWithValue("@iId", ingId);
                    cmdPI.ExecuteNonQuery();
                }

                // Qiymət əlavə et
                SqlCommand cmdPrice = new SqlCommand(
                    "INSERT INTO PizzaPrices(PizzaId, SizeId, Price) VALUES(@pId, @sId, @price)", conn);
                cmdPrice.Parameters.AddWithValue("@pId", newPizzaId);
                cmdPrice.Parameters.AddWithValue("@sId", sizeChoice);
                cmdPrice.Parameters.AddWithValue("@price", price);
                cmdPrice.ExecuteNonQuery();
            }

            Console.WriteLine("Yeni pizza əlavə olundu!");
        }
    }
}

    class Pizza
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }
        public decimal MinPrice { get; set; }
    }

    class Ingredient
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }

    class PizzaSize
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }
