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

public class JavaGateway
{
    public static void main(String[] args) throws Exception
    {
        addClassToJsonMap(args[0]);
    }

    public static void addClassToJsonMap(String className) throws Exception
    {
        Class<?> clazz = null;
        clazz = Class.forName(className);
        JsonObject json = convertClassToJson(clazz);
        FileWriter fw = new FileWriter("NewJavaClass.json");
        fw.write(json.toString());
        fw.close();
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
