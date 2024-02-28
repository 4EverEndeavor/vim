import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

public class JavaGateway
{
    public static void main(String[] args) throws Exception
    {
        createClassInfoFile(args[0]);
    }

    public static void createClassInfoFile(String className) throws IOException {
        Class<?> clazz = null;
        try {
            clazz = Class.forName(className);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(clazz.getSimpleName() + ".txt"))) {
            writer.write("Class Name: " + clazz.getSimpleName() + "\n\n");

            // Fields
            Field[] fields = clazz.getDeclaredFields();
            if (fields.length > 0) {
                writer.write("Fields: \n\n");
                for (Field field : fields) {
                    writer.write(Modifier.toString(field.getModifiers()) + " " + field.getType().getSimpleName() + " " + field.getName() + "\n");
                }
                writer.write("\n");
            }

            // Methods
            Method[] methods = clazz.getDeclaredMethods();
            if (methods.length > 0) {
                writer.write("Methods: \n\n");
                for (Method method : methods) {
                    writer.write(Modifier.toString(method.getModifiers()) + " " + method.getReturnType().getSimpleName() + " " + method.getName() + "(");
                    Class<?>[] paramTypes = method.getParameterTypes();
                    for (int i = 0; i < paramTypes.length; i++) {
                        writer.write(paramTypes[i].getSimpleName());
                        if (i < paramTypes.length - 1) {
                            writer.write(", ");
                        }
                    }
                    writer.write(")\n");
                }
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
