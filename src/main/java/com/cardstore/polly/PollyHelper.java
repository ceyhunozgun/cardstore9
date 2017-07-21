package com.cardstore.polly;

import java.io.IOException;
import java.io.InputStream;

import com.amazonaws.ClientConfiguration;
import com.amazonaws.auth.DefaultAWSCredentialsProviderChain;
import com.amazonaws.regions.Region;
import com.amazonaws.services.polly.AmazonPollyClient;
import com.amazonaws.services.polly.model.DescribeVoicesRequest;
import com.amazonaws.services.polly.model.DescribeVoicesResult;
import com.amazonaws.services.polly.model.OutputFormat;
import com.amazonaws.services.polly.model.SynthesizeSpeechRequest;
import com.amazonaws.services.polly.model.SynthesizeSpeechResult;
import com.amazonaws.services.polly.model.Voice;

public class PollyHelper {

	private final AmazonPollyClient polly;
	private final String voiceId = "Joanna";
	
	public PollyHelper(Region region) {
		// create an Amazon Polly client in a specific region
		polly = new AmazonPollyClient();
		polly.setRegion(region);
	}

	public InputStream synthesize(String text, OutputFormat format) {
		SynthesizeSpeechRequest synthReq = new SynthesizeSpeechRequest().withText(text).withVoiceId(voiceId).withOutputFormat(format);
		
		SynthesizeSpeechResult synthRes = polly.synthesizeSpeech(synthReq);

		return synthRes.getAudioStream();
	}
}
