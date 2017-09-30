using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;

namespace Assets.Editor.EditorLinq
{
	public class DeleteNegativeRotatedGameobjects : EditorWindow
	{
		[MenuItem("Window/DeleteNegativeRotatedGameobjects")]
		public static void ShowWindow()
		{
			EditorWindow.GetWindow(typeof(DeleteNegativeRotatedGameobjects));
		}

		void OnGUI()
		{
			List<GameObject> toDestroy = new List<GameObject>();
			if (GUILayout.Button("Delete Negative Rotated Objects"))
				foreach (GameObject go in Selection.gameObjects)
					if (go.transform.localRotation.eulerAngles.x < 0 || go.transform.localRotation.eulerAngles.x > 120)
						toDestroy.Add(go);

			foreach (GameObject go in toDestroy)
				DestroyImmediate(go);
		}
	}
}
