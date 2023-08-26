// Made with Amplify Shader Editor v1.9.1.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ANGELWARE/GlassRefraction"
{
	Properties
	{
		_BaseColour("Base Colour", Color) = (1,1,1,0.01960784)
		_AlbedoCubemap("Albedo Cubemap", CUBE) = "linearGrey" {}
		[Toggle(_ALBEDOISOPACITY_ON)] _AlbedoisOpacity("Albedo is Opacity", Float) = 0
		_OpacityMap("OpacityMap", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.97
		_GlossMap("Gloss Map", 2D) = "white" {}
		_NormalMap("Normal Map", CUBE) = "bump" {}
		_NormalMapScale("Normal Map Scale", Float) = 0.3
		[Header(Refraction)]
		_ChromaticAberration("Chromatic Aberration", Range( 0 , 0.3)) = 0.1
		_IOR("IOR", Range( -4 , 4)) = 1.01
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+2000" }
		Cull Off
		GrabPass{ }
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _ALBEDOISOPACITY_ON
		#pragma multi_compile _ALPHAPREMULTIPLY_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 uv_texcoord;
			float3 worldRefl;
			INTERNAL_DATA
			float4 screenPos;
			float3 worldPos;
		};

		uniform samplerCUBE _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _NormalMapScale;
		uniform samplerCUBE _AlbedoCubemap;
		uniform float4 _BaseColour;
		uniform float _Metallic;
		uniform sampler2D _GlossMap;
		uniform float4 _GlossMap_ST;
		uniform float _Smoothness;
		uniform sampler2D _OpacityMap;
		uniform float4 _OpacityMap_ST;
		uniform sampler2D _GrabTexture;
		uniform float _ChromaticAberration;
		uniform float _IOR;

		inline float4 Refraction( Input i, SurfaceOutputStandard o, float indexOfRefraction, float chomaticAberration ) {
			float3 worldNormal = o.Normal;
			float4 screenPos = i.screenPos;
			#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
			#else
				float scale = 1.0;
			#endif
			float halfPosW = screenPos.w * 0.5;
			screenPos.y = ( screenPos.y - halfPosW ) * _ProjectionParams.x * scale + halfPosW;
			#if SHADER_API_D3D9 || SHADER_API_D3D11
				screenPos.w += 0.00000000001;
			#endif
			float2 projScreenPos = ( screenPos / screenPos.w ).xy;
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float3 refractionOffset = ( indexOfRefraction - 1.0 ) * mul( UNITY_MATRIX_V, float4( worldNormal, 0.0 ) ) * ( 1.0 - dot( worldNormal, worldViewDir ) );
			float2 cameraRefraction = float2( refractionOffset.x, refractionOffset.y );
			float4 redAlpha = tex2D( _GrabTexture, ( projScreenPos + cameraRefraction ) );
			float green = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 - chomaticAberration ) ) ) ).g;
			float blue = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 + chomaticAberration ) ) ) ).b;
			return float4( redAlpha.r, green, blue, redAlpha.a );
		}

		void RefractionF( Input i, SurfaceOutputStandard o, inout half4 color )
		{
			#ifdef UNITY_PASS_FORWARDBASE
			color.rgb = color.rgb + Refraction( i, o, _IOR, _ChromaticAberration ) * ( 1 - color.a );
			color.a = 1;
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float3 uv_NormalMap3 = i.uv_texcoord;
			uv_NormalMap3.xy = i.uv_texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 texCUBENode15 = UnpackScaleNormal( texCUBE( _NormalMap, uv_NormalMap3 ), _NormalMapScale );
			o.Normal = texCUBENode15;
			float4 texCUBENode3 = texCUBE( _AlbedoCubemap, normalize( WorldReflectionVector( i , texCUBENode15 ) ) );
			float div4=256.0/float(256);
			float4 posterize4 = ( floor( ( texCUBENode3 * float4( 0,0,0,0 ) ) * div4 ) / div4 );
			o.Albedo = ( posterize4 * _BaseColour ).rgb;
			o.Metallic = _Metallic;
			float2 uv_GlossMap = i.uv_texcoord * _GlossMap_ST.xy + _GlossMap_ST.zw;
			o.Smoothness = ( tex2D( _GlossMap, uv_GlossMap ) * _Smoothness ).r;
			float2 uv_OpacityMap = i.uv_texcoord * _OpacityMap_ST.xy + _OpacityMap_ST.zw;
			#ifdef _ALBEDOISOPACITY_ON
				float staticSwitch39 = tex2D( _OpacityMap, uv_OpacityMap ).r;
			#else
				float staticSwitch39 = texCUBENode3.a;
			#endif
			o.Alpha = ( _BaseColour.a * staticSwitch39 );
			o.Normal = o.Normal + 0.00001 * i.screenPos * i.worldPos;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha finalcolor:RefractionF fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xyz = customInputData.uv_texcoord;
				o.customPack1.xyz = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xyz;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldRefl = -worldViewDir;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19102
Node;AmplifyShaderEditor.StickyNoteNode;5;-966.9106,-455.1501;Inherit;False;473.1777;159.3273;Credits;;1,1,1,1;The world reflection posterization was studied from RollTheRed's CrushedRefraction shader. Thank you for your contributions to the community, it's greatly appreciated and your assets have helped me learn much about shader creation with amplify.$$"https://rollthered.booth.pm/";0;0
Node;AmplifyShaderEditor.WorldReflectionVector;1;-1095.703,20.23977;Inherit;True;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;10;-1334.04,449.9901;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;15;-1488.696,12.84102;Inherit;True;Property;_NormalMap;Normal Map;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;17;-1150.039,240.7903;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;19;-450.7736,203.3714;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;18;-125.697,182.3233;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;20;-862.3815,224.4195;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;8;-1309.061,304.7943;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;21;-827.6348,327.2534;Inherit;False;Property;_Metallic;Metallic;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-827.6348,404.2534;Float;False;Property;_Smoothness;Smoothness;5;0;Create;True;0;0;0;False;0;False;0.97;0.988;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosterizeNode;4;-250.6663,-116.2976;Inherit;True;256;2;1;COLOR;0,0,0,0;False;0;INT;256;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;26;-749.6348,118.2534;Inherit;False;Property;_BaseColour;Base Colour;0;0;Create;True;0;0;0;False;0;False;1,1,1,0.01960784;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;28;-293.8959,243.4976;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;30;-337.4933,351.3431;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;32;3.568359,192.3907;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;31;144.2187,270.5991;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;408.7774,124.4098;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ANGELWARE/GlassRefraction;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Translucent;0.5;True;True;2000;False;Opaque;;Transparent;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;9;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;66.74137,78.95191;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;202.2127,500.9359;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;39;-106.9071,483.4232;Inherit;False;Property;_AlbedoisOpacity;Albedo is Opacity;2;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;14;-463.9773,479.012;Inherit;True;Property;_OpacityMap;OpacityMap;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;41;-308.2912,118.5664;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-494.3552,-85.75275;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;40;-266.1587,403.3819;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StickyNoteNode;43;44.41829,603.0659;Inherit;False;150;100;Note;;1,1,1,1;I don't know if this is correct, but it works lol.;0;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1730.688,28.45344;Inherit;False;Property;_NormalMapScale;Normal Map Scale;8;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-660.3362,565.0964;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;46;44.66382,257.0964;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-201.867,321.3416;Float;False;Property;_IOR;IOR;11;0;Create;True;0;0;0;False;0;False;1.01;1.02;-4;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;47;-238.3362,283.0964;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;48;-498.3362,416.0964;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;44;-1010.336,491.0964;Inherit;True;Property;_GlossMap;Gloss Map;6;0;Create;True;0;0;0;False;0;False;-1;None;1b1397b2c79224547a75dc085e3f5c37;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-847.0593,-82.50763;Inherit;True;Property;_AlbedoCubemap;Albedo Cubemap;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;linearGrey;LockedToCube;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;1;0;15;0
WireConnection;15;5;16;0
WireConnection;17;0;15;0
WireConnection;19;0;20;0
WireConnection;18;0;19;0
WireConnection;20;0;17;0
WireConnection;4;1;25;0
WireConnection;28;0;30;0
WireConnection;30;0;21;0
WireConnection;32;0;26;4
WireConnection;31;0;32;0
WireConnection;0;0;33;0
WireConnection;0;1;18;0
WireConnection;0;3;28;0
WireConnection;0;4;46;0
WireConnection;0;8;7;0
WireConnection;0;9;13;0
WireConnection;33;0;4;0
WireConnection;33;1;26;0
WireConnection;13;0;31;0
WireConnection;13;1;39;0
WireConnection;39;1;40;0
WireConnection;39;0;14;1
WireConnection;41;0;3;4
WireConnection;25;0;3;0
WireConnection;40;0;41;0
WireConnection;45;0;44;0
WireConnection;45;1;22;0
WireConnection;46;0;47;0
WireConnection;47;0;48;0
WireConnection;48;0;45;0
WireConnection;3;1;1;0
ASEEND*/
//CHKSM=3C06A88F6FB07F3095AAFBCD90C834AD3BE03F38