import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.jsontype.TypeResolverBuilder;
import com.fasterxml.jackson.databind.jsontype.impl.StdTypeResolverBuilder;
import com.fasterxml.jackson.annotation.JsonTypeInfo;

public class JavaToJsonFile {

    public static void main(String[] args) throws Exception {
        ObjectMapper mapper = new ObjectMapper();
        Obje

        TypeResolverBuilder<?> typeResolverBuilder = new StdTypeResolverBuilder();

        // Register the interface with the TypeResolverBuilder
        typeResolverBuilder.init(JsonTypeInfo.Id.NAME, null);
        typeResolverBuilder.inclusion(JsonTypeInfo.As.PROPERTY);
        typeResolverBuilder.typeProperty("type");

        // Set the TypeResolverBuilder on the ObjectMapper
        mapper.setDefaultTyping(typeResolverBuilder);

        // Create an instance of the interface
        MyInterface object = new MyInterfaceImpl();

        // Set the values of the object's fields
        object.setName("John Doe");
        object.setAge(30);

        // Write the object to JSON
        String json = mapper.writeValueAsString(object);

        // Print the JSON to the console
        System.out.println(json);
    }
}

interface MyInterface {
    String getName();
    void setName(String name);
    int getAge();
    void setAge(int age);
}

class MyInterfaceImpl implements MyInterface {
    private String name;
    private int age;

    @Override
    public String getName() {
        return name;
    }

    @Override
    public void setName(String name) {
        this.name = name;
    }

    @Override
    public int getAge() {
        return age;
    }

    @Override
    public void setAge(int age) {
        this.age = age;
    }
}
