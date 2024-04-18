    public #1:insert# update#2:insert#Selective(#3:insert#SelectiveUpdateType update)
            throws Exception
    {
        if(update.obj().get#4:insert#() == null)
        {
            throw new Exception("#5:insert# must be set during threat case update");
        }
        if(update.obj().get#6:insert#() == null)
        {
            throw new Exception("#7:insert# must be set during threat case update");
        }

        final UpdateExpressionBuilder ueb = buildSelectiveUpdateExpression(update);

        final UpdateItemSpec updateItemSpec = new UpdateItemSpec()
                .withPrimaryKey(#8:insert#.HASHKEY_NAME, update.obj().get#9:insert#().toString(),
                        #10:insert#.RANGEKEY_NAME, update.obj().get#11:insert#().toString())
                .withConditionExpression("attribute_exists(#hashkey) AND attribute_exists(#sortkey)")
                .withUpdateExpression(ueb.build())
                .withNameMap(ueb.getNameMap().with("#hashkey", #12:insert#.HASHKEY_NAME).with("#sortkey",
                        #13:insert#.RANGEKEY_NAME));

        if(ueb.getValueMap().size() > 0)
        {
            updateItemSpec.withValueMap(ueb.getValueMap());
        }

        ObjectTraceType retVal = null;

        _logger.info("Performing selective update on #14:insert#: {}", update.obj().get#15:insert#().toString());

        try
        {
            UpdateItemOutcome uio = _#16:insert#.updateItem(updateItemSpec);

            if(uio.getItem() != null)
            {
                retVal = _objectMapper.readValue(uio.getItem().toJSON(), #17:insert#.class);
            }
        }
        catch (ConditionalCheckFailedException e)
        {
            _logger.error("Update attempted on non-existent item");
        }

        return retVal;
    }
