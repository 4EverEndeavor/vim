    public List<#1:insert#> find#2:insert#ForOrg(final RUUID #3:insert#) throws Exception
    {
        final QuerySpec query = new QuerySpec()
                .withHashKey(#4:insert#.HASHKEY_NAME, #5:insert#.toString())

        final List<#6:insert#> retVal = new ArrayList<>();

        for (Page<Item, QueryOutcome> page : #7:insert#.query(query).pages())
        {
            Iterator<Item> itemIterator = page.iterator();
            while(itemIterator.hasNext())
            {
                retrVal.add(_objectMapper.readValue(itemIterator.next().toJSON(), #8:insert#.class));
            }
        }

        return retVal;
    }
