using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ImageRay : MonoBehaviour {
    [Range(0f, 1f)]//添加此特性后可在Inspector面板中使用滑动条控制grayScaleAmount
    //控制灰度值
    public float grayScaleAmount = 1.0f;

    private Material CurMaterial
    {
        get
        {
            return GetComponent<Image>().material;
        }
    }
    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        CurMaterial.SetFloat("_LuminosityAmount", grayScaleAmount);
    }
}
