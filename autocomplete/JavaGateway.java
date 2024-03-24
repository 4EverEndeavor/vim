import java.util.Map;
import java.util.HashMap;
import java.io.FileWriter;
import javax.json.JsonObject;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObjectBuilder;
import javax.json.Json;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Constructor;
import javax.json.JsonReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.File;
import java.nio.file.Paths;
import java.net.URLClassLoader;
import java.net.URL;

public class JavaGateway
{
    public static void main(String[] args) throws Exception
    {
        Class<?> clazz = null;
        // clazz = loadClassFromClassPath(args[0]);
        clazz = loadClassFromClassFile(args[0]);
        try
        {
            clazz = loadClassFromClassPath(args[0]);
        }
        catch(Exception e)
        {
            // do nothing
            System.out.println("Exception: " + e.getMessage());
        }
        try
        {
            clazz = loadClassFromClassFile(args[0]);
        }
        catch(Exception e)
        {
            // do nothing
            System.out.println("Exception: " + e.getMessage());
        }

        if(clazz != null)
        {
            addClassToJsonMap(clazz);
        }
    }

    public static void addClassToJsonMap(Class<?> clazz) throws Exception
    {
        JsonObject json = convertClassToJson(clazz);
        FileWriter fw = new FileWriter("NewJavaClass.json");
        fw.write(json.toString());
        fw.close();
    }

    public static Class<?> loadClassFromClassPath(String fullFilePath) throws Exception
    {
        return Class.forName(getClassNameFromFullPath(fullFilePath));
    }

    public static Class<?> loadClassFromClassFile(String fullFilePath) throws Exception
    {
        File classFile = new File(fullFilePath);

        // Create a URLClassLoader to load the compiled class
        URLClassLoader classLoader = new URLClassLoader(new URL[]{classFile.toURI().toURL()});

        Class<?> clazz = classLoader.loadClass("com.rhombus.common.api.RUUID");

        // Load the class
        return Class.forName(getClassNameFromFullPath(fullFilePath), true, classLoader);
    }

    public static String getClassNameFromFullPath(String fullFilePath)
    {
        String className = Paths.get(fullFilePath).getFileName().toString().replace(".class", "");
        System.out.println("class name: " + className);
        return className;
    }

    public static JsonObject convertClassToJson(Class<?> clazz) {
        JsonObjectBuilder classBuilder = Json.createObjectBuilder();

        // Add class name
        classBuilder.add("class_name", clazz.getName());

        // Add declared fields
        Field[] fields = clazz.getDeclaredFields();
        for (Field field : fields) {
            JsonObject fieldObject = Json.createObjectBuilder()
                .add("name", field.getName())
                .add("type", field.getType().getName())
                .build();
            classBuilder.add("fields", fieldObject);
        }

        // Add declared methods
        Method[] methods = clazz.getDeclaredMethods();
        for (Method method : methods) {
            JsonObjectBuilder methodBuilder = Json.createObjectBuilder()
                .add("name", method.getName())
                .add("return_type", method.getReturnType().getName());

            // Add parameter types
            Class<?>[] parameterTypes = method.getParameterTypes();
            JsonArrayBuilder paraBuilder = Json.createArrayBuilder();
            for (Class<?> parameterType : parameterTypes) {
                paraBuilder.add(parameterType.getName());
            }
            methodBuilder.add("parameters", paraBuilder.build());

            classBuilder.add("methods", methodBuilder);
        }

        // Add superclass information
        Class<?> superClass = clazz.getSuperclass();
        if (superClass != null) {
            JsonObject superObject = Json.createObjectBuilder()
                .add("superclass_name", superClass.getName())
                .build();
        }

        // constructors
        Constructor<?>[] constructors = clazz.getConstructors();
        JsonArrayBuilder constructorBuilder = Json.createArrayBuilder();
        if (constructors != null) {
            for(Constructor constructor : constructors)
            {
                Class<?>[] parameters = constructor.getParameterTypes();
                JsonArrayBuilder paraBuilder = Json.createArrayBuilder();
                for(Class parameter : parameters)
                {
                    paraBuilder.add(parameter.getName());
                }
                constructorBuilder.add(paraBuilder.build());
            }
        }
        classBuilder.add("constructors", constructorBuilder.build());

        return classBuilder.build();
    }
}
