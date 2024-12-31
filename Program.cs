using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Xml;
using System.Text.RegularExpressions;

namespace Replace_Code_FrontBack
{
    internal class Program
    {
        static void Main(string[] args)
        {
            // Ruta del archivo .aspx
            string rutaBase = AppDomain.CurrentDomain.BaseDirectory;
            string archivoAspx = Path.Combine(rutaBase, "Archivos", "EvaluacionMedicaGeneral.aspx");

            // Verificar si el archivo existe
            if (!File.Exists(archivoAspx))
            {
                Console.WriteLine($"El archivo no existe: {archivoAspx}");
                return;
            }

            // Leer el contenido del archivo
            string contenido = File.ReadAllText(archivoAspx);

            // Expresión regular para identificar el fieldset
            string patronFieldset = @"<fieldset[^>]*(id|class)\s*=\s*[""']?FDiagnosticos[""']?[^>]*>.*?</fieldset>";

            // Reemplazo con el nuevo contenido
            string nuevoContenido = @"<asp:DiagnosticosJson runat=""server"" ID=""DiagnosticosJson"" />";

            // Realizar el reemplazo
            string contenidoModificado = Regex.Replace(contenido, patronFieldset, nuevoContenido, RegexOptions.Singleline);


            //reemplazando los if

            // Expresión regular para identificar los bloques de if, incluyendo corchetes internos
            string patronIf = @"if\s*\(\s*\$get\(['""]?(HdfHistoricoDiagnostico|TbHistoricoDiagnostico|HdfDiagnosticos)['""]?\)[^}]*\{([^{}]*\{[^}]*\}[^{}]*)*\}";
            string patronIfTabla = @"if\s*\(\s*\$get\(""TbHistoricoDiagnostico""\)\.getElementsByTagName\('tbody'\)\[0\]\.getElementsByTagName\('tr'\)\.length\s*==\s*0\)[^}]*\{[^}]*\}";

            // Reemplazo para comentar los bloques if
            contenidoModificado = Regex.Replace(contenido, patronIf, m =>
            {
                return $"/*\n{m.Value}\n*/";  // Comenta el bloque if encontrado
            }, RegexOptions.Singleline);

            // Reemplazo adicional para comentar el código que no está dentro de los bloques if
            string patronAsignacion = @"\$get\(['""]?(HdfHistoricoDiagnostico|HdfDiagnosticos)['""]?\)\.value\s*=\s*""\s*"";";
            contenidoModificado = Regex.Replace(contenidoModificado, patronAsignacion, m =>
            {
                return $"/*\n{m.Value}\n*/";  // Comenta la asignación que no está dentro de los if
            });            

            // Reemplazo para comentar el bloque if
            contenidoModificado = Regex.Replace(contenidoModificado, patronIfTabla, m =>
            {
                return $"/*\n{m.Value}\n*/";  // Comentar solo este bloque if
            }, RegexOptions.Singleline);





            // Guardar los cambios en el archivo
            File.WriteAllText(archivoAspx, contenidoModificado);
            Console.WriteLine("Reemplazo completado.");







        }
    }
}
