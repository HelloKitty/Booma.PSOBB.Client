Shader "Custom/CharacterScreenBackgroundShader" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_uvAnimationTileX ("X tile Count", Int) = 3
		_uvAnimationTileY ("Y tile Count", Int) = 2
		_framesPerSecond ("Speed of the animation in frames per second.", Float) = 10.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert noshadow noambient nolightmap novertexlights nodynlightmap nodirlightmap nofog nometa noforwardadd nolppv noshadowmask

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 2.0

		sampler2D _MainTex;
		uint _uvAnimationTileX;
		uint _uvAnimationTileY;
		float _framesPerSecond;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			uint index = (uint)(_Time.y * _framesPerSecond);
			// repeat when exhausting all frames
			index = index % (_uvAnimationTileX * _uvAnimationTileY);

			// split into horizontal and vertical index
			uint uIndex = index % _uvAnimationTileX;
			uint vIndex = index / _uvAnimationTileX;

			// build offset
			float2 offset = float2(uIndex / (float)_uvAnimationTileX, 1.0f - (1.0f / (float)_uvAnimationTileY) - (float)vIndex / (float)_uvAnimationTileY);

			fixed4 c = tex2D(_MainTex, IN.uv_MainTex + offset);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
