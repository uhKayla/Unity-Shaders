// Upgrade NOTE: upgraded instancing buffer 'KaylaBasicIridescence' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Kayla/Basic Iridescence"
{
	Properties
	{
		_BaseColor("Base Color", Color) = (0,0,0,0)
		_Albedo("Albedo", 2D) = "white" {}
		_MetallicMap("Metallic Map", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_IridescenceMap("Iridescence Map", 2D) = "white" {}
		_IridescenceAmount("Iridescence Amount", Range( 0 , 1)) = 1
		_IridescenceTile("Iridescence Tile", Vector) = (10,10,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			float3 viewDir;
		};

		uniform sampler2D _Albedo;
		uniform sampler2D _IridescenceMap;
		uniform sampler2D _MetallicMap;

		UNITY_INSTANCING_BUFFER_START(KaylaBasicIridescence)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Albedo_ST)
#define _Albedo_ST_arr KaylaBasicIridescence
			UNITY_DEFINE_INSTANCED_PROP(float4, _BaseColor)
#define _BaseColor_arr KaylaBasicIridescence
			UNITY_DEFINE_INSTANCED_PROP(float4, _MetallicMap_ST)
#define _MetallicMap_ST_arr KaylaBasicIridescence
			UNITY_DEFINE_INSTANCED_PROP(float2, _IridescenceTile)
#define _IridescenceTile_arr KaylaBasicIridescence
			UNITY_DEFINE_INSTANCED_PROP(float, _IridescenceAmount)
#define _IridescenceAmount_arr KaylaBasicIridescence
			UNITY_DEFINE_INSTANCED_PROP(float, _Metallic)
#define _Metallic_arr KaylaBasicIridescence
			UNITY_DEFINE_INSTANCED_PROP(float, _Smoothness)
#define _Smoothness_arr KaylaBasicIridescence
		UNITY_INSTANCING_BUFFER_END(KaylaBasicIridescence)

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 _Albedo_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Albedo_ST_arr, _Albedo_ST);
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST_Instance.xy + _Albedo_ST_Instance.zw;
			float4 tex2DNode17 = tex2D( _Albedo, uv_Albedo );
			float4 _BaseColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_BaseColor_arr, _BaseColor);
			o.Albedo = ( tex2DNode17 * _BaseColor_Instance ).rgb;
			float3 ase_worldNormal = i.worldNormal;
			float dotResult3 = dot( ase_worldNormal , i.viewDir );
			float4 appendResult4 = (float4(dotResult3 , dotResult3 , 0.0 , 0.0));
			float2 _IridescenceTile_Instance = UNITY_ACCESS_INSTANCED_PROP(_IridescenceTile_arr, _IridescenceTile);
			float _IridescenceAmount_Instance = UNITY_ACCESS_INSTANCED_PROP(_IridescenceAmount_arr, _IridescenceAmount);
			o.Emission = ( tex2D( _IridescenceMap, ( appendResult4 * float4( _IridescenceTile_Instance, 0.0 , 0.0 ) ).rg ) * _IridescenceAmount_Instance ).rgb;
			float4 _MetallicMap_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MetallicMap_ST_arr, _MetallicMap_ST);
			float2 uv_MetallicMap = i.uv_texcoord * _MetallicMap_ST_Instance.xy + _MetallicMap_ST_Instance.zw;
			float4 tex2DNode21 = tex2D( _MetallicMap, uv_MetallicMap );
			float _Metallic_Instance = UNITY_ACCESS_INSTANCED_PROP(_Metallic_arr, _Metallic);
			o.Metallic = ( tex2DNode21.r * _Metallic_Instance );
			float _Smoothness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Smoothness_arr, _Smoothness);
			o.Smoothness = ( tex2DNode21.a * _Smoothness_Instance );
			o.Alpha = ( tex2DNode17.a * _BaseColor_Instance.a );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

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
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
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
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldNormal = IN.worldNormal;
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
Version=18707
73;91;2234;652;1293.245;526.1572;1.112903;True;True
Node;AmplifyShaderEditor.WorldNormalVector;2;-989.4337,0.09654284;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;1;-987.8337,138.2636;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;3;-744.1675,58.72938;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;4;-613.0885,49.43354;Inherit;False;COLOR;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;19;-714.6704,263.2738;Inherit;False;InstancedProperty;_IridescenceTile;Iridescence Tile;7;0;Create;True;0;0;False;0;False;10,10;10,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-495.702,209.5646;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;17;-407.0338,-211.1035;Inherit;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;False;0;False;-1;None;65c205c6da4835e4d9ec049eb425156a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-345.6338,602.4963;Inherit;False;InstancedProperty;_Smoothness;Smoothness;4;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-415.2173,334.0755;Inherit;True;Property;_MetallicMap;Metallic Map;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;9;-295.0337,-415.9034;Inherit;False;InstancedProperty;_BaseColor;Base Color;0;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-325.1106,86.21103;Inherit;True;Property;_IridescenceMap;Iridescence Map;5;0;Create;True;0;0;False;0;False;-1;None;f5b14c29eebaec046b8f114573f4993d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-314.2338,271.2964;Inherit;False;InstancedProperty;_IridescenceAmount;Iridescence Amount;6;0;Create;True;0;0;False;0;False;1;0.066;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-344.0338,533.2964;Inherit;False;InstancedProperty;_Metallic;Metallic;3;0;Create;True;0;0;False;0;False;0;0.033;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;26.56623,46.49648;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;82.43562,-309.2532;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-11.21729,299.0755;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-13.21729,385.0756;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;131.6168,-119.6187;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;387.1065,-68.09632;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Kayla/Basic Iridescence;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;2;0
WireConnection;3;1;1;0
WireConnection;4;0;3;0
WireConnection;4;1;3;0
WireConnection;18;0;4;0
WireConnection;18;1;19;0
WireConnection;6;1;18;0
WireConnection;12;0;6;0
WireConnection;12;1;13;0
WireConnection;20;0;17;0
WireConnection;20;1;9;0
WireConnection;22;0;21;1
WireConnection;22;1;14;0
WireConnection;24;0;21;4
WireConnection;24;1;11;0
WireConnection;25;0;17;4
WireConnection;25;1;9;4
WireConnection;0;0;20;0
WireConnection;0;2;12;0
WireConnection;0;3;22;0
WireConnection;0;4;24;0
WireConnection;0;9;25;0
ASEEND*/
//CHKSM=BF5F99D84A7CE32432DC758F768D5D17B24ACC53