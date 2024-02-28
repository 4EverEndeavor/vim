import java.io.BufferedWriter;
import java.io.FileWriter;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

public class JavaGateway
{
    public static void main(String[] args) throws Exception
    {
        createClassInfoFile(args[0]);
    }

    public static void createClassInfoFile(String className) throws Exception
    {
        Class<?> clazz = null;
        try
        {
            clazz = Class.forName(className);
        }
        catch (ClassNotFoundException e)
        {
            e.printStackTrace();
        }

        // Methods
        for(Method method : clazz.getDeclaredMethods())
        {
            System.out.println(method.getName() + "()");
            String paramsStr = "";
            Class<?>[] paramTypes = method.getParameterTypes();
            for (int i = 0; i < paramTypes.length; i++)
            {
                paramsStr += paramTypes[i].getSimpleName() + ", ";
            }
            paramsStr = paramsStr.substring(0, paramsStr.length());
            System.out.println(method.getName() + "(" + paramsStr + ")");
        }
    }
}
