using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SearchState : BaseBehavior
{
    //Global Stats
    public StateController stateCon;
    public EnemySoundController enemySfx;

    public float moveSpeed;
    public float turnSpeed;
    public float distTolerance;
    public float rotSpeed;

    int dumbCounter;
    const int dumbCheck = 200;
    int stuckCounter;
    const int stuckCheck = 50;

    bool reached;
    

    //Search Stats
    int searchCounter;

    List<GameObject> searchPos;

    // Use this for initialization
    void Awake ()
    {
        
        searchPos = new List<GameObject>();
        reached = false;

        dumbCounter = 0;
        stuckCounter = 0;
    }

    public override void Enter()
    {
        ResetStats();

        var searchList = GetComponentInChildren<EnemySearch>().GetSearchables();
        foreach (GameObject s in searchList)
        {
            searchPos.Add(s);
        }
        

        stateCon.CurrState = StateController.State.search;
    }

    public override void Exit()
    {

        stateCon.CurrState = StateController.State.ponderEnter;
    }

    public override void StateLoop()
    {
        if (searchCounter < searchPos.Count)
        {
            
            if (reached)
            {
                //call interactable search function here
                ++searchCounter;
                reached = false;
                return;
            }
            
            else
            {
                Vector3 target = searchPos[searchCounter].transform.GetChild(0).transform.position - transform.position;
                var newDir = Quaternion.LookRotation(target, Vector3.forward);
                newDir.x = 0;
                newDir.y = 0;
                transform.rotation = Quaternion.Slerp(transform.rotation, newDir, Time.deltaTime * rotSpeed);

                transform.position = Vector2.MoveTowards(transform.position, target, moveSpeed * Time.deltaTime);
                ++dumbCounter;

                enemySfx.PlaySearch();


                Vector2 currPos = transform.position;
                
                float distA = Vector2.Distance(currPos, target);

                if (distA <= distTolerance)
                {
                    reached = true;
                    dumbCounter = 0;
                }
            }
        }

        else
        {
            stateCon.CurrState = StateController.State.searchExit;
            return;
        }
    }

    public override void ResetStats()
    {
        searchPos.Clear();

        reached = false;
        
        searchCounter = 0;
        dumbCounter = 0;
        stuckCounter = 0;
    }

    // Update is called once per frame
    void Update ()
    { 
		
	}
}
