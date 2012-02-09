#!/bin/bash

# function apply_patch patch_file
# this function no more deal with directory case since it is managed
# in an upper layer
function apply_patch {
apply="patch -p1 -E -d"

case "${1}" in
*\.tar\.gz|*\.tgz|*\.tar\.bz|*\.tar\.bz2|*\.tbz|*\.tbz2)
	echo "Error with ${1}";
	echo "Archives into a directory or another archive is not supported";
	return 1;
	;;
*\.gz)
	type="gzip"; uncomp="gunzip -dc"; ;;
*\.bz)
	type="bzip"; uncomp="bunzip -dc"; ;;
*\.bz2)
	type="bzip2"; uncomp="bunzip2 -dc"; ;;
*\.zip)
	type="zip"; uncomp="unzip -d"; ;;
*\.Z)
	type="compress"; uncomp="uncompress -c"; ;;
*\.diff*)
	type="diff"; uncomp="cat"; ;;
# '*' at the end is needed for patch.arm for example
*\.patch*)
	type="patch"; uncomp="cat"; ;;
*)
	echo "Unsupported format file for ${1}, skip it";
	return 0;
	;;
esac

echo ""
echo "Applying ${1} using ${type}: "
echo ${1} | cat >> ${builddir}/.applied_patches_list
${uncomp} ${1} | ${apply} ${builddir}
if [ $? != 0 ] ; then
	echo "Patch failed! Please fix ${1}!"
	return 1
fi
}

# entry point
builddir=${1}
patchdir=${2}
shift 2
patchlist=${@}
patchesdir="${builddir}/../$(basename $builddir)-patches"

# check directories
if [ ! -d "${patchdir}" ] ; then
	echo "Aborting: ${patchdir} is not a directory."
	exit 1
fi
if [ ! -d "${builddir}" ] ; then
	echo "Aborting: ${builddir} is not a directory."
	exit 1
fi

# go to the patch directory because $patchlist is interpreted when doing
# for i in $patchlist
pushd ${patchdir}
index=0
for i in $patchlist ; do
	patchlist_interpreted[${index}]="$i"
	index=`expr ${index} + 1`
	echo patchlist_interpreted[${index}]=$i
done
popd

for index in "${!patchlist_interpreted[@]}" ; do
	file="${patchlist_interpreted[${index}]}"
	patch_path="${patchdir}/${file}"
	# three cases: directory, archive, file patch (compressed or not)
	# directory
	if [ -d "${patch_path}" ] ; then
		for p in $(ls ${patch_path}) ; do
			apply_patch "${patch_path}/${p}" || exit 1
		done
	# archive
	elif echo $file | grep -q -E "tar\.bz$|tar\.bz2$|tbz$|tbz2$|tar\.gz$|tgz$" ; then
		mkdir "${patchesdir}"
		# extract archive
		if echo $file | grep -q -E "tar\.bz$|tar\.bz2$|tbz$|tbz2$" ; then
			tar_options="-xjf"
		else
			tar_options="-xzf"
		fi
		tar -C ${patchesdir} --strip-components=1 ${tar_options} ${patch_path}
		# apply patches from the archive
		for p in $(find ${patchesdir} | sort) ; do
			apply_patch "${p}" || { rm -rf "${patchesdir}" ; exit 1; }
		done
		rm -rf "${patchesdir}"
	# file which is not an archive
	else
		apply_patch "${patch_path}" || exit 1
	fi
done

# check for rejects...
if [ "`find ${builddir}/ '(' -name '*.rej' -o -name '.*.rej' ')' -print`" ] ; then
    echo "Aborting.  Reject files found."
    exit 1
fi

# remove backup files
find ${builddir}/ '(' -name '*.orig' -o -name '.*.orig' ')' -exec rm -f {} \;

