using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PonderState : BaseBehavior
{
    //Global Stats
    public StateController stateCon;
    public IdleState idleState;
    bool canSearch;
    

    // Use this for initialization
    void Start ()
    {
		
	}

    public override void Enter()
    {

        //canSearch = false;

        //int searchRoll = Random.Range(0, 100);

        //if (searchRoll < 25)
        //{
        //    canSearch = true;
        //}

        //else 
        if (!idleState.canIdle)
        {
            StartCoroutine(idleState.CDIdle());
        }

        stateCon.CurrState = StateController.State.ponder;
    }

    public override void StateLoop()
    {
        //if(canSearch)
        //{
        //    stateCon.CurrState = StateController.State.searchEnter;
        //}
        //else if 
            if (idleState.canIdle) { stateCon.CurrState = StateController.State.idleEnter; }
    }

    // Update is called once per frame
    void Update ()
    {
		
	}

    
}
