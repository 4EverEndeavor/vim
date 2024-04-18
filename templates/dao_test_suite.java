

import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.model.ConditionalCheckFailedException;
import com.rhombus.common.api.RUUID;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

public class ThreatCaseDaoTest extends SuiteInitializer
{
    @Autowired
    private ThreatCasesDao _threatCaseDao;

    @Autowired
    @Qualifier(ThreatCasesModel.TABLE_BEAN_NAME)
    protected Table _threatCaseTable;

    @BeforeEach
    public void cleanupTables()
    {
        _resetTable(_threatCaseTable, ThreatCasesModel.HASHKEY_NAME, ThreatCasesModel.RANGEKEY_NAME);
    }

    @Test
    public void testUpdateThreatCaseStatus() throws Exception
    {
        RU
        final RUUID orgUuid = RUUID.randomRUUID();
        final RUUID threatCaseUuid = RUUID.randomRUUID();
        final String verificationId = UUID.randomUUID().toString();

        AlertMonitoringThreatCaseType initialCase = new AlertMonitoringThreatCaseType();
        initialCase.setOrgUuid(orgUuid);
        initialCase.setUuid(threatCaseUuid);
        initialCase.setCreatedAtMillis(System.currentTimeMillis());
        initialCase.setStatus(ThreatCaseStatus.INITIATED);

        _threatCaseDao.insertThreatCase(initialCase);

        final AlertMonitoringThreatCaseType duplicateThreatCase = new AlertMonitoringThreatCaseType();
        duplicateThreatCase.setUuid(threatCaseUuid);
        duplicateThreatCase.setOrgUuid(orgUuid);
        duplicateThreatCase.setCreatedAtMillis(System.currentTimeMillis());

        Assertions.assertThrows(ConditionalCheckFailedException.class, () -> _threatCaseDao.insertThreatCase(duplicateThreatCase));

        ThreatCaseSelectiveUpdateType threatCaseUpdate = new ThreatCaseSelectiveUpdateType(orgUuid, threatCaseUuid);

        // UUID for noonlight
        threatCaseUpdate.update().setNoonlightVerificationId(verificationId);

        // change status to ESCALATED
        threatCaseUpdate.update().setStatus(ThreatCaseStatus.ESCALATED);

        _threatCaseDao.updateThreatCaseSelective(threatCaseUpdate);

        AlertMonitoringThreatCaseType updatedThreatCase = _threatCaseDao.findThreatCase(orgUuid, threatCaseUuid);

        Assertions.assertNotNull(updatedThreatCase);
        Assertions.assertNotNull(updatedThreatCase.getNoonlightVerificationId());
        Assertions.assertNotNull(updatedThreatCase.getStatus());
        Assertions.assertEquals(ThreatCaseStatus.ESCALATED, updatedThreatCase.getStatus());
        Assertions.assertEquals(verificationId, updatedThreatCase.getNoonlightVerificationId());
    }
}
