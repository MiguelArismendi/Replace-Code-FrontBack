using System;
using System.IO;
using System.Text.RegularExpressions;


namespace Replace_Code_FrontBack
{
    internal class Program
    {
        static void Main(string[] args)
        {
            string RutaProyecto = AppDomain.CurrentDomain.BaseDirectory;
            string CarpetaArchivos = Path.Combine(RutaProyecto, "Archivos");

            if (!Directory.Exists(CarpetaArchivos))
            {
                Console.WriteLine($"La carpeta no existe: {CarpetaArchivos}");
                return;
            }

            string[] Archivos = Directory.GetFiles(CarpetaArchivos, "*.*", SearchOption.TopDirectoryOnly);


            foreach (string Archivo in Archivos)
            {
                string Extension = Path.GetExtension(Archivo).ToLower();
                string ContenidoOriginal = File.ReadAllText(Archivo);
                string ContenidoModificado = ContenidoOriginal;

                string ArchivoViejo = Path.Combine(Path.GetDirectoryName(Archivo),
                                    Path.GetFileNameWithoutExtension(Archivo) + "Viejo" + Extension);

                if (Extension == ".aspx")
                {
                    // Modificaciones para archivos .aspx
                    ContenidoModificado = ProcesarFormularioAspx(ContenidoModificado);
                }
                else if (Extension == ".vb")
                {
                    // Modificaciones para archivos .vb
                    ContenidoModificado = ProcesarFormularioVb(ContenidoModificado);
                }
                else
                {
                    Console.WriteLine($"Extensión no soportada: {Archivo}");
                    continue;
                }

                // Crear archivo antiguo
                File.WriteAllText(ArchivoViejo, ContenidoOriginal);

                // Sobrescribir archivo con los cambios
                File.WriteAllText(Archivo, ContenidoModificado);

                Console.WriteLine($"Procesado: {Archivo}");
            }
        }


        static string ProcesarFormularioAspx(string ContenidoFormulario)
        {
            // Ejemplo: Reemplazo específico para archivos .aspx
            string PatronExpresionRegular, NuevaLineaReemplazar;
            // Se busca el inicio del llenado del historico de los diagnósticos y se agrega la función que reemplaza este llenado
            PatronExpresionRegular = @"if\s*\(\s*\$get\s*\(\s*['""]HdfHistoricoDiagnostico['""]\s*\)\.value\s*!=\s*[""']\s*[""']\s*\)\s*\{";
            NuevaLineaReemplazar = "DiagnosticosJsonSelecciona();";
            ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, m => $"{NuevaLineaReemplazar}\n{m.Value}", RegexOptions.IgnoreCase);

            // Se busca el fieldset en el HTML que contiene los diagnósticos y se reemplaza por el control de usuario
            PatronExpresionRegular = @"<fieldset[^>]*(id|class)\s*=\s*[""']?FDiagnosticos[""']?[^>]*>.*?</fieldset>";
            NuevaLineaReemplazar = @"<asp:DiagnosticosJson runat=""server"" ID=""DiagnosticosJson"" />";
            ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, NuevaLineaReemplazar, RegexOptions.Singleline);

            // Se busca en el archivo el bloque de código que llena el histórico y los diagnósticos para comentar todo este código
            PatronExpresionRegular = @"if\s*\(\s*\$get\(['""]?(HdfHistoricoDiagnostico|TbHistoricoDiagnostico|HdfDiagnosticos)['""]?\)[^}]*\{([^{}]*\{[^}]*\}[^{}]*)*\}";
            ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, m => { return $"/*\n{m.Value}\n*/"; }, RegexOptions.Singleline);

            //Se busca en el archivo el bloque de código que limpia las variables que llenan los diagnósticos y se comentan
            PatronExpresionRegular = @"\$get\(['""]?(HdfHistoricoDiagnostico|HdfDiagnosticos)['""]?\)\.value\s*=\s*""\s*"";";
            ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, m => { return $"/*\n{m.Value}\n*/"; });

            //Se busca en el archivo el bloque de validación de la tabla del histórico de los diagnósticos y se comenta
            PatronExpresionRegular = @"if\s*\(\s*\$get\(""TbHistoricoDiagnostico""\)\.getElementsByTagName\('tbody'\)\[0\]\.getElementsByTagName\('tr'\)\.length\s*==\s*0\)[^}]*\{[^}]*\}";
            ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, m => { return $"/*\n{m.Value}\n*/"; }, RegexOptions.Singleline);


            //Se busca el inicio del content 4 y se agrega el registro del archivo de usuario y un content0 con el style necesario para que funcionen los autocomplete
            PatronExpresionRegular = @"<asp:Content\s+[^>]*\bID\s*=\s*""Content4""[^>]*>";
            NuevaLineaReemplazar = @"<asp:Content ID=""Content0"" ContentPlaceHolderID=""H"" runat=""Server"">
<style>
     .ui-menu {
      background: #86C1E6;
     }
</style>
</asp:Content>

<%@ Register Src=""~/HistoriaClinica/DiagnosticosJson.ascx"" TagPrefix=""asp"" TagName=""DiagnosticosJson"" %>";
            ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, m => $"{NuevaLineaReemplazar}\n{m.Value}", RegexOptions.IgnoreCase);

            //Se busca en el código el bloque que trae los estilos y se comentan ya que interfieren con el estilo del control de usuario
            PatronExpresionRegular = @"<link\s+[^>]*href\s*=\s*""\.\./Estilos/jquery-ui\.css""[^>]*>";
            ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, match => $"<!-- {match.Value} -->");

            //Se busca en el código el bloque que trae los estilos y se comentan ya que interfieren con el estilo del control de usuario
            PatronExpresionRegular = @"<script\s+[^>]*src\s*=\s*""\.\./Scripts/jquery-ui\.js""[^>]*>\s*</script>";
            ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, match => $"<!-- {match.Value} -->");


            //Se busca el inicio del content 4 y se agrega el registro del archivo de usuario y un content0 con el style necesario para que funcionen los autocomplete
            PatronExpresionRegular = @"(if\s*\([^\)]*Diagnosticos\.length\s*>\s*0\s*\)\s*\{)([\s\S]*?)(?=\s*\}(?!\s*\)\s*;))";//@"(if\s*\([^\)]*Diagnosticos\.length\s*>\s*0\s*\)\s*\{)([\s\S]*?)(?!\s*\)\s*;)"; 
            NuevaLineaReemplazar = "                            DiagnosticosJsonSelecciona();";
            ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, m =>
            {
                // Capturamos la apertura y el cierre del if
                string Apertura = m.Groups[1].Value;  // Mantiene el `if` y su apertura
                string Cierre = m.Groups[3].Value;    // Mantiene el cierre del bloque `if`                

                // Concatenamos el bloque con el nuevo contenido
                return Apertura + "\n" + NuevaLineaReemplazar + Cierre;
            });

            PatronExpresionRegular = @"(if\s*\([^\)]*HistoricoDiagnosticos\.length\s*>\s*0\s*\)\s*\{)([\s\S]*?)(\})";
            ContenidoFormulario =  Regex.Replace(ContenidoFormulario, PatronExpresionRegular, m =>
            {
                string Apertura = m.Groups[1].Value;  // `if` y apertura de la llave
                string Cuerpo = m.Groups[2].Value;    // Cuerpo del if
                string Cierre = m.Groups[3].Value;    // Cierre de la llave

                // Comentar todo el contenido del bloque
                return $"//{Apertura}\n    //{Cuerpo.Replace("\n", "\n    //")}\n //{Cierre}";
            });

            return ContenidoFormulario;
        }

        static string ProcesarFormularioVb(string ContenidoFormulario)
        {
            string[] PatronesExpresionesRegulares = new string[]
             {
            @"SqlDs\.SelectCommand\s*=\s*""HistoriaClinica\.HistoricoDiagnosticosSelecciona""[\s\S]*?End If",
            @"SqlDs\.SelectCommand\s*=\s*""HistoriaClinica\.DiagnosticosSelecciona""[\s\S]*?End If"
             };

            foreach (var Patron in PatronesExpresionesRegulares)
            {
                ContenidoFormulario = Regex.Replace(
                    ContenidoFormulario,
                    Patron,
                    Concidencia => "' " + Concidencia.Value.Replace("\r\n", "\r\n' "),
                    RegexOptions.Singleline
                );
            }          

            return ContenidoFormulario;
        }
    }
}
