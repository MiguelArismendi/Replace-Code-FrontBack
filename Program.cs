using System;
using System.Collections.Generic;
using System.IO;
using System.Linq.Expressions;
using System.Text.RegularExpressions;
using System.Web.Script.Serialization;



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

                if (Extension == ".aspx" || Extension == ".vb")
                {
                    // Modificaciones para archivos .aspx
                    ContenidoModificado = ProcesarFormularios(ContenidoModificado);
                }
                //else if (Extension == ".vb")
                //{
                //    // Modificaciones para archivos .vb
                //    ContenidoModificado = ProcesarFormularioVb(ContenidoModificado);
                //}
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


        static string ProcesarFormularios(string ContenidoFormulario)
        {

            string RutaProyecto = AppDomain.CurrentDomain.BaseDirectory;
            string RutaArchivoExpresiones = Path.Combine(RutaProyecto, "Archivos/ExpresionesRegulares.json");

            if (!File.Exists(RutaArchivoExpresiones)) // Cambiar Directory.Exists a File.Exists
            {
                Console.WriteLine($"El archivo no existe: {RutaArchivoExpresiones}");
                throw new InvalidOperationException($"El archivo no existe: {RutaArchivoExpresiones}");
            }

            List<JsonExpresionRegular> ExpresionesRegulares;

            var ContenidoJson = File.ReadAllText(RutaArchivoExpresiones); // Cambiar contenidoJson a ContenidoJson

            var Serializador = new JavaScriptSerializer();

            // Deserializar el JSON a un diccionario
            ExpresionesRegulares = Serializador.Deserialize<List<JsonExpresionRegular>>(ContenidoJson);


            if (ExpresionesRegulares == null)
            {
                throw new InvalidOperationException("Debes cargar las expresiones regulares antes de procesar.");
            }

            foreach (var PatronExpresionRegular in ExpresionesRegulares)
            {                
                var OpcionesExpresion = PatronExpresionRegular.ObtenerOpcionesRegex();

                switch (PatronExpresionRegular.MetodoUsar)
                {
                    case "ReemplazarCodigo":
                        ContenidoFormulario = ReemplazarCodigo(ContenidoFormulario, PatronExpresionRegular.PatronExpresionRegular, PatronExpresionRegular.NuevaLineaReemplazar, OpcionesExpresion, PatronExpresionRegular.IncluirLineaOriginal);
                        break;
                    case "ComentarCodigoJavascript":
                        ContenidoFormulario = ComentarCodigoJavascript(ContenidoFormulario, PatronExpresionRegular.PatronExpresionRegular);
                        break;
                    case "ComentarCodigoHTML":
                        ContenidoFormulario = ComentarCodigoHTML(ContenidoFormulario, PatronExpresionRegular.PatronExpresionRegular);
                        break;
                    case "ComentarCodigoVisualBasic":
                        ContenidoFormulario = ComentarCodigoVisualBasic(ContenidoFormulario, PatronExpresionRegular.PatronExpresionRegular, OpcionesExpresion);
                        break;
                    case "ReemplazarCodigoBloques":
                        ContenidoFormulario = ReemplazarCodigoBloques(ContenidoFormulario, PatronExpresionRegular.PatronExpresionRegular, PatronExpresionRegular.NuevaLineaReemplazar, OpcionesExpresion, PatronExpresionRegular.IncluirLineaOriginal);
                        break;
                    case "ComentarCodigoJavascriptBloques":
                        ContenidoFormulario = ComentarCodigoJavascriptBloques(ContenidoFormulario, PatronExpresionRegular.PatronExpresionRegular, OpcionesExpresion);
                        break;
                    default:
                        throw new InvalidOperationException($"Método no reconocido: {PatronExpresionRegular.MetodoUsar}");
                }
                
            }

            //Se busca el inicio del content 4 y se agrega el registro del archivo de usuario y un content0 con el style necesario para que funcionen los autocomplete
            //PatronExpresionRegular = @"(if\s*\([^\)]*Diagnosticos\.length\s*>\s*0\s*\)\s*\{)([\s\S]*?)(?=\s*\}(?!\s*\)\s*;))";//@"(if\s*\([^\)]*Diagnosticos\.length\s*>\s*0\s*\)\s*\{)([\s\S]*?)(?!\s*\)\s*;)"; 
            //NuevaLineaReemplazar = "                            Diagnosticos.DiagnosticosSelecciona();";
            //ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, m =>
            //{
            //    // Capturamos la apertura y el cierre del if
            //    string Apertura = m.Groups[1].Value;  // Mantiene el `if` y su apertura
            //    string Cierre = m.Groups[3].Value;    // Mantiene el cierre del bloque `if`                

            //    // Concatenamos el bloque con el nuevo contenido
            //    return Apertura + "\n" + NuevaLineaReemplazar + Cierre;
            //});

            //PatronExpresionRegular = @"(if\s*\([^\)]*HistoricoDiagnosticos\.length\s*>\s*0\s*\)\s*\{)([\s\S]*?)(\})";
            //ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, m =>
            //{
            //    string Apertura = m.Groups[1].Value;  // `if` y apertura de la llave
            //    string Cuerpo = m.Groups[2].Value;    // Cuerpo del if
            //    string Cierre = m.Groups[3].Value;    // Cierre de la llave

            //    // Comentar todo el contenido del bloque
            //    return $"//{Apertura}\n    //{Cuerpo.Replace("\n", "\n    //")}\n //{Cierre}";
            //});

            return ContenidoFormulario;
        }

        static string ComentarCodigoJavascript(string ContenidoFormulario, string PatronExpresionRegular, RegexOptions OpcionesExpresion = RegexOptions.None)
        {
            //Se busca en el archivo el bloque de código que limpia las variables que llenan los diagnósticos y se comentan            
            ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, Coincidencia => {

                if (ContenidoFormulario.Contains($"/*\n{Coincidencia.Value}\n*/"))
                {
                    return Coincidencia.Value;
                }

                return $"/*\n{Coincidencia.Value}\n*/"; 
            
            }, OpcionesExpresion);

            return ContenidoFormulario;
        }

        static string ComentarCodigoJavascriptBloques(string ContenidoFormulario, string PatronExpresionRegular, RegexOptions OpcionesExpresion = RegexOptions.None)
        {
            ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, m =>
            {
                string Apertura = m.Groups[1].Value;  // `if` y apertura de la llave
                string Cuerpo = m.Groups[2].Value;    // Cuerpo del if
                string Cierre = m.Groups[3].Value;    // Cierre de la llave


                if (ContenidoFormulario.Contains($"//{Apertura}"))
                {
                    return m.Value;
                }

                // Comentar todo el contenido del bloque
                return $"//{Apertura}\n    //{Cuerpo.Replace("\n", "\n    //")}\n //{Cierre}";
            });

            return ContenidoFormulario;
        }

        static string ComentarCodigoHTML(string ContenidoFormulario, string PatronExpresionRegular, RegexOptions OpcionesExpresion = RegexOptions.None)
        {
            ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, Coincidencia => {

                if (ContenidoFormulario.Contains($"<!-- {Coincidencia.Value} -->"))
                {
                    return Coincidencia.Value;
                }

                return $"<!-- {Coincidencia.Value} -->";
            
            }, OpcionesExpresion);

            return ContenidoFormulario;
        }

        static string ComentarCodigoVisualBasic(string ContenidoFormulario, string PatronExpresionRegular, RegexOptions OpcionesExpresion = RegexOptions.None)
        {

            string patronModificado = $"^(?!\\s*').*?({PatronExpresionRegular})";

            ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, Coincidencia =>
            {
                if (ContenidoFormulario.Contains($"'{Coincidencia.Value}"))
                {
                    return Coincidencia.Value;
                }

                return $" '{Coincidencia.Value.Replace("\r\n", "\r\n' ")} ";
            }, OpcionesExpresion);

            return ContenidoFormulario;
        }

        static string ReemplazarCodigo(string ContenidoFormulario, string PatronExpresionRegular, string NuevoContenido, RegexOptions OpcionesExpresion = RegexOptions.None, bool IncluirLineaOriginal = false)
        {

            if (ContenidoFormulario.Contains(NuevoContenido))
            {
                return ContenidoFormulario;
            }

            ContenidoFormulario = Regex.Replace(
                ContenidoFormulario,
                PatronExpresionRegular,
                m => $"{NuevoContenido}{(IncluirLineaOriginal ? $"\n{m.Value}" : "")}",
                OpcionesExpresion);

            return ContenidoFormulario;
        }

        static string ReemplazarCodigoBloques(string ContenidoFormulario, string PatronExpresionRegular, string NuevoContenido, RegexOptions OpcionesExpresion = RegexOptions.None, bool IncluirLineaOriginal = false)
        {

            if (ContenidoFormulario.Contains(NuevoContenido))
            {
                return ContenidoFormulario;
            }

            ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, m =>
            {
                // Capturamos la apertura y el cierre del if
                string Apertura = m.Groups[1].Value;  // Mantiene el `if` y su apertura
                string Cierre = m.Groups[3].Value;    // Mantiene el cierre del bloque `if`                

                // Concatenamos el bloque con el nuevo contenido
                return Apertura + "\n" + NuevoContenido + Cierre;
            });

            return ContenidoFormulario;
        }

        [Obsolete("This metodh is obsolete, use ProcesarFormularios instead")]
        static string ProcesarFormularioVb(string ContenidoFormulario)
        {
            string RutaProyecto = AppDomain.CurrentDomain.BaseDirectory;
            string RutaArchivoExpresiones = Path.Combine(RutaProyecto, "Archivos/ExpresionesRegularesBackend.json");

            if (!File.Exists(RutaArchivoExpresiones)) // Cambiar Directory.Exists a File.Exists
            {
                Console.WriteLine($"El archivo no existe: {RutaArchivoExpresiones}");
                throw new InvalidOperationException($"El archivo no existe: {RutaArchivoExpresiones}");
            }

            List<JsonExpresionRegular> ExpresionesRegulares;

            var ContenidoJson = File.ReadAllText(RutaArchivoExpresiones); // Cambiar contenidoJson a ContenidoJson

            var Serializador = new JavaScriptSerializer();

            // Deserializar el JSON a un diccionario
            ExpresionesRegulares = Serializador.Deserialize<List<JsonExpresionRegular>>(ContenidoJson);

            if (ExpresionesRegulares == null)
            {
                throw new InvalidOperationException("Debes cargar las expresiones regulares antes de procesar.");
            }

            foreach (var PatronExpresionRegular in ExpresionesRegulares)
            {
                if (string.IsNullOrEmpty(PatronExpresionRegular.NuevaLineaReemplazar))
                {
                    var OpcionesExpresion = PatronExpresionRegular.ObtenerOpcionesRegex();
                    ContenidoFormulario = ComentarCodigoVisualBasic(ContenidoFormulario, PatronExpresionRegular.PatronExpresionRegular, OpcionesExpresion);
                }
            }

            return ContenidoFormulario;
        }

        public class JsonExpresionRegular
        {
            public string Nombre { get; set; }
            public string PatronExpresionRegular { get; set; }
            public string NuevaLineaReemplazar { get; set; }
            public string MetodoUsar { get; set; }
            public bool IncluirLineaOriginal { get; set; }
            public string OpcionesExpresion { get; set; }

            public RegexOptions ObtenerOpcionesRegex()
            {
                if (string.IsNullOrEmpty(OpcionesExpresion)) return RegexOptions.None;

                var OpcionSinEspacios = OpcionesExpresion.Trim().ToLower();

                switch (OpcionSinEspacios)
                {
                    case "ignorecase":
                        return RegexOptions.IgnoreCase;
                    case "multiline":
                        return RegexOptions.Multiline;
                    case "singleline":
                        return RegexOptions.Singleline;
                    case "explicitcapture":
                        return RegexOptions.ExplicitCapture;
                    case "compiled":
                        return RegexOptions.Compiled;
                    case "righttoleft":
                        return RegexOptions.RightToLeft;
                    case "cultureinvariant":
                        return RegexOptions.CultureInvariant;
                    case "ecmascript":
                        return RegexOptions.ECMAScript;
                    default:
                        throw new InvalidOperationException($"Opción de expresión regular no reconocida: {OpcionesExpresion}");
                }
            }
        }
    }
}
