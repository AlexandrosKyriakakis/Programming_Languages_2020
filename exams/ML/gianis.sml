fun oddeven []=raise Subscript
	|oddeven [a]=1
	|oddeven (l)=
		let 
		val flag=ref false (*false->odd, true->even*)
		fun helper([],temp)=tempm
				|helper((x::xs,temp)= 
					let fun walk([],maxl)=maxl
					if((!flag=false andalso x mod 2=0)orelse(!flag=true andalso x mod 2=1))then 
					(flag:= not(!flag);walk(xs,maxl+1)
					else maxl
				val curr=walk(x::xs,0)
			in 
				if(temp<curr)then (temp=curr; helper(xs,0))
			end
	in 
		helper(l,0)
	end;
oddeven ([1,2,3]);
