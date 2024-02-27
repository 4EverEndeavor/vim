package ##<PACKAGE>##;

import org.junit.jupiter.api.*;
import org.mockito.*;

import com.fasterxml.jackson.databind.ObjectMapper;

class ##<CLASSNAME>##Test
{

    ##<MOCKS>##

    private AutoCloseable _autoCloseable;

    @InjectMocks
    private final ##<CLASSNAME>## ##<className>## = new ##<CLASSNAME>##(##<PAREMETERS>##)

    @BeforeEach
    public void openMocks()
    {
        _autoCloseable = MockitoAnnotations.openMocks(this);
    }

    @AfterEach
    public void closeMocks() throws Exception
    {
        _autoCloseable.close();
    }

    ##<TESTMETHODS>##
}
