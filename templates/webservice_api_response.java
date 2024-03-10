package com.rhombus.cloud.webservice.api.<TAG>;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import com.rhombus.cloud.webservice.api.BaseApiResponse;

@JsonIgnoreProperties(ignoreUnknown = true)
@JsonPropertyOrder(alphabetic = true)
public class <TAG>WSResponse extends BaseApiResponse
{

}
