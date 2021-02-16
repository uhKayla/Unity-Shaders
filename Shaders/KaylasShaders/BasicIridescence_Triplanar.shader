// Upgrade NOTE: upgraded instancing buffer 'KaylaBasicIridescenceTriplanar' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Kayla/Basic Iridescence (Triplanar)"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_MetallicMap("Metallic Map", 2D) = "white" {}
		_BaseColor("Base Color", Color) = (0,0,0,0)
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_IridescenceMap("Iridescence Map", 2D) = "white" {}
		_IridescenceAmount("Iridescence Amount", Range( 0 , 1)) = 1
		_IridescenceTile("Iridescence Tile", Vector) = (10,10,0,0)
		_Tiling("Tiling", Vector) = (1,1,0,0)
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
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		sampler2D _Albedo;
		uniform sampler2D _IridescenceMap;
		sampler2D _MetallicMap;

		UNITY_INSTANCING_BUFFER_START(KaylaBasicIridescenceTriplanar)
			UNITY_DEFINE_INSTANCED_PROP(float4, _BaseColor)
#define _BaseColor_arr KaylaBasicIridescenceTriplanar
			UNITY_DEFINE_INSTANCED_PROP(float2, _Tiling)
#define _Tiling_arr KaylaBasicIridescenceTriplanar
			UNITY_DEFINE_INSTANCED_PROP(float2, _IridescenceTile)
#define _IridescenceTile_arr KaylaBasicIridescenceTriplanar
			UNITY_DEFINE_INSTANCED_PROP(float, _IridescenceAmount)
#define _IridescenceAmount_arr KaylaBasicIridescenceTriplanar
			UNITY_DEFINE_INSTANCED_PROP(float, _Metallic)
#define _Metallic_arr KaylaBasicIridescenceTriplanar
			UNITY_DEFINE_INSTANCED_PROP(float, _Smoothness)
#define _Smoothness_arr KaylaBasicIridescenceTriplanar
		UNITY_INSTANCING_BUFFER_END(KaylaBasicIridescenceTriplanar)


		inline float4 TriplanarSampling26( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		inline float4 TriplanarSampling29( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float2 _Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Tiling_arr, _Tiling);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar26 = TriplanarSampling26( _Albedo, ase_worldPos, ase_worldNormal, 1.0, _Tiling_Instance, 1.0, 0 );
			float4 _BaseColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_BaseColor_arr, _BaseColor);
			o.Albedo = ( triplanar26 * _BaseColor_Instance ).xyz;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult3 = dot( ase_worldNormal , ase_worldViewDir );
			float4 appendResult4 = (float4(dotResult3 , dotResult3 , 0.0 , 0.0));
			float2 _IridescenceTile_Instance = UNITY_ACCESS_INSTANCED_PROP(_IridescenceTile_arr, _IridescenceTile);
			float _IridescenceAmount_Instance = UNITY_ACCESS_INSTANCED_PROP(_IridescenceAmount_arr, _IridescenceAmount);
			o.Emission = ( tex2D( _IridescenceMap, ( appendResult4 * float4( _IridescenceTile_Instance, 0.0 , 0.0 ) ).rg ) * _IridescenceAmount_Instance ).rgb;
			float4 triplanar29 = TriplanarSampling29( _MetallicMap, ase_worldPos, ase_worldNormal, 1.0, _Tiling_Instance, 1.0, 0 );
			float _Metallic_Instance = UNITY_ACCESS_INSTANCED_PROP(_Metallic_arr, _Metallic);
			o.Specular = ( triplanar29.x * _Metallic_Instance );
			float _Smoothness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Smoothness_arr, _Smoothness);
			o.Gloss = ( triplanar29.w * _Smoothness_Instance );
			o.Alpha = ( triplanar26.w * _BaseColor_Instance.a );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Lambert alpha:fade keepalpha fullforwardshadows 

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
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
178;64;2234;924;887.1765;545.209;1;True;True
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;1;-987.8337,138.2636;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;2;-989.4337,0.09654284;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;28;-888.1489,-276.8669;Inherit;False;InstancedProperty;_Tiling;Tiling;8;0;Create;True;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WorldPosInputsNode;27;-851.423,-447.1411;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;3;-744.1675,58.72938;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;33;-651.4344,-68.15788;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;32;-718.2878,-116.5688;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;34;-1096.354,-1.304725;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;31;-1126.323,-58.93678;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;19;-714.6704,263.2738;Inherit;False;InstancedProperty;_IridescenceTile;Iridescence Tile;7;0;Create;True;0;0;False;0;False;10,10;10,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;4;-613.0885,49.43354;Inherit;False;COLOR;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;35;-1059.469,326.0453;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-495.702,209.5646;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;30;-1144.766,358.3194;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;6;-325.1106,86.21103;Inherit;True;Property;_IridescenceMap;Iridescence Map;5;0;Create;True;0;0;False;0;False;-1;None;f5b14c29eebaec046b8f114573f4993d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;9;-255.0336,-143.9034;Inherit;False;InstancedProperty;_BaseColor;Base Color;2;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-345.6338,602.4963;Inherit;False;InstancedProperty;_Smoothness;Smoothness;4;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-344.0338,533.2964;Inherit;False;InstancedProperty;_Metallic;Metallic;3;0;Create;True;0;0;False;0;False;0;0.033;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;29;-454.1166,337.4555;Inherit;True;Spherical;World;False;Metallic Map;_MetallicMap;white;1;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Metallic Map;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-314.2338,271.2964;Inherit;False;InstancedProperty;_IridescenceAmount;Iridescence Amount;6;0;Create;True;0;0;False;0;False;1;0.066;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;26;-376.5616,-351.9346;Inherit;True;Spherical;World;False;Albedo;_Albedo;white;0;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Albedo;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;26.56623,46.49648;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;131.6168,-119.6187;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;82.43562,-309.2532;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-13.21729,385.0756;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-11.21729,299.0755;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;387.1065,-68.09632;Float;False;True;-1;2;ASEMaterialInspector;0;0;Lambert;Kayla/Basic Iridescence (Triplanar);False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;2;0
WireConnection;3;1;1;0
WireConnection;33;0;27;0
WireConnection;32;0;28;0
WireConnection;34;0;33;0
WireConnection;31;0;32;0
WireConnection;4;0;3;0
WireConnection;4;1;3;0
WireConnection;35;0;34;0
WireConnection;18;0;4;0
WireConnection;18;1;19;0
WireConnection;30;0;31;0
WireConnection;6;1;18;0
WireConnection;29;9;35;0
WireConnection;29;3;30;0
WireConnection;26;9;27;0
WireConnection;26;3;28;0
WireConnection;12;0;6;0
WireConnection;12;1;13;0
WireConnection;25;0;26;4
WireConnection;25;1;9;4
WireConnection;20;0;26;0
WireConnection;20;1;9;0
WireConnection;24;0;29;4
WireConnection;24;1;11;0
WireConnection;22;0;29;1
WireConnection;22;1;14;0
WireConnection;0;0;20;0
WireConnection;0;2;12;0
WireConnection;0;3;22;0
WireConnection;0;4;24;0
WireConnection;0;9;25;0
ASEEND*/
//CHKSM=F5E30896FFEAB9107055A4A5D819617CC21261BB