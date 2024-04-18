    public #1:insert# findObjectTrace(final RUUID #2:insert#, final RUUID #3:insert#)
            throws Exception
    {
        final GetItemSpec getItemSpec = new GetItemSpec();
        getItemSpec.withPrimaryKey(#4:insert#.HASHKEY_NAME, #5:insert#.toString(),
                #6:insert#.RANGEKEY_NAME, #7:insert#.toString());

        final Item retrievedItem = _#8:insert#.getItem(getItemSpec);

        #9:insert# retVal = null;

        if(retrievedItem != null)
        {
            retVal = _objectMapper.readValue(retrievedItem.toJSON(), #10:insert#.class);
        }

        return retVal;
    }
